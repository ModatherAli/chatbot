import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../../controller/chat_controller.dart';
import '../../controller/theme_controller.dart';
import '../../packages.dart';
import '../settings/settings_screen.dart';
import '../widgets/widgets.dart';
import 'widgets/chat_messages_list.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ChatController _chatController = Get.put(ChatController());

  final SpeechToText _speechToText = SpeechToText();

  final ScrollController _scrollController = ScrollController();

  bool _aiIsWriting = false;
  bool _isRecording = false;
  bool _showRecording = false;
  bool _speechEnabled = false;
  bool _speechInit = false;
  String _lastWords = '';

  Future _sendMessage(String msg) async {
    setState(() {
      _textController.clear();
      _aiIsWriting = true;
    });

    await _chatController.onUserSendMessage(msg);
    await _chatController.onAISendMessage(msg);

    setState(() {
      _aiIsWriting = false;
    });
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechInit = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening(String localeId) async {
    await _speechToText.listen(
      onResult: _onSpeechResult,
      // listenMode: ListenMode.dictation,
      localeId: localeId,
      // listenFor: const Duration(minutes: 1),
    );
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() async {
      _lastWords = result.recognizedWords;
      if (result.finalResult) {
        log(_lastWords);
        await _sendMessage(_lastWords);
        _lastWords = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Chatbot 👋'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              _isRecording = false;
              _showRecording = false;
              setState(() {});
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: const SettingsScreen()));
            },
            icon: const Icon(
              Icons.menu,
              size: 30,
            ),
          ),
        ],
      ),
      body: GetBuilder<ChatController>(builder: (_) {
        return Stack(
          children: [
            ListView(
              padding:
                  EdgeInsets.only(bottom: _showRecording ? 270 : 120, top: 10),
              reverse: true,
              controller: _scrollController,
              children: [
                Visibility(visible: _aiIsWriting, child: const AIWriting()),
                ChatMessagesList(messages: _chatController.chatMessage),
              ],
            ),
          ],
        );
      }),
      bottomSheet: GetBuilder<SettingsController>(builder: (themeController) {
        return AnimatedContainer(
          color: Theme.of(context).scaffoldBackgroundColor,
          duration: const Duration(milliseconds: 500),
          onEnd: () {
            setState(() {
              _showRecording = _isRecording;
            });
          },
          height: _isRecording ? 250 : null,
          constraints: const BoxConstraints(maxHeight: 300, minHeight: 50),
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Visibility(
              visible: _isRecording,
              replacement: Container(
                constraints: const BoxConstraints(maxHeight: 150),
                child: UserTextField(
                  textController: _textController,
                  onChanged: (value) {
                    setState(() {});
                  },
                  onMicPressed: () {
                    _isRecording = true;
                    setState(() {});
                  },
                  onSendText: () async {
                    await _sendMessage(_textController.text);
                  },
                ),
              ),
              child: MicView(
                text: _speechToText.isListening
                    ? _lastWords
                    : 'Hi. You can ask me anything'.tr,
                speechEnabled: _speechToText.isListening,
                onRecord: () async {
                  _speechEnabled = !_speechEnabled;
                  if (_speechInit) {
                    if (_speechToText.isNotListening) {
                      _startListening(themeController.voiceLocal);
                    } else {
                      _stopListening();
                    }
                  } else {
                    _initSpeech();
                  }

                  setState(() {});
                },
                onKeyboardPressed: () {
                  setState(() {
                    _isRecording = false;
                  });
                },
              )),
        );
      }),
    );
  }
}
