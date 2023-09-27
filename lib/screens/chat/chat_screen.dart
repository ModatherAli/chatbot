import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../../controller/chat_controller.dart';
import '../../controller/theme_controller.dart';
import '../../modules/message.dart';
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
  final ChatController _messageController =
      Get.put(ChatController(), permanent: true);

  final SpeechToText _speechToText = SpeechToText();
  final List<Message> _newMessages = [];
  final List<Message> _savedChatMessage = [];
  final ScrollController _scrollController = ScrollController();
  bool _aiIsWriting = false;
  bool _isRecording = false;
  bool _showRecording = false;
  bool _speechEnabled = false;
  bool _speechInit = false;
  String _lastWords = '';
  // final SettingsController _themeController = Get.find();

  Future _sendMessage(String msg) async {
    Message messageModule;
    StringBuffer stringBuffer = StringBuffer();
    stringBuffer.write(msg);
    messageModule = Message(
      message: stringBuffer,
      isAI: false,
    );
    _scrollController.jumpTo(0);
    _newMessages.add(messageModule);
    setState(() {
      _textController.clear();
      _aiIsWriting = true;
    });
    await _messageController.insertQRDate(message: msg);
    await _receiveMessage(msg, false);
    setState(() {
      _aiIsWriting = false;
    });
  }

  _receiveMessage(String msg, bool isImage) async {
    Message messageModule;
    Map<String, dynamic> response = {};
    // await _openAiAPI.sendMessage(messageText: msg, wantsImage: isImage);

    StringBuffer stringBuffer = StringBuffer();

    if (isImage) {
      log(response['data'][0]['url']);
      stringBuffer.write(response['data'][0]['url']);
      messageModule = Message(
        message: stringBuffer,
        isAI: true,
        isImage: true,
      );

      _newMessages.add(messageModule);
      await _messageController.insertQRDate(
        message: messageModule.message.toString().trim(),
        isAI: 1,
        isImage: 1,
      );
    } else {
      await _sendChatMessage(msg);
    }
  }

  Future _sendChatMessage(String msg) async {
    _newMessages.add(
      Message(
        message: StringBuffer(),
        isAI: true,
      ),
    );
    setState(() {});
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

  _getMessage() async {
    Message messageModule;

    StringBuffer stringBuffer = StringBuffer();
    stringBuffer.write('Hi. You can ask me anything'.tr);
    messageModule = Message(
      isAI: true,
      message: stringBuffer,
    );
    _newMessages.add(messageModule);
    setState(() {});
    await _messageController.readData();
    for (var message in _messageController.messages) {
      StringBuffer buffer = StringBuffer();
      buffer.write(message['message'].toString());
      if (message['is_ai'] == 1) {
        messageModule = Message(
          isAI: true,
          isImage: message['is_image'] == 1,
          message: buffer,
        );
      } else {
        messageModule = Message(
          isAI: false,
          message: buffer,
        );
      }
      _savedChatMessage.add(messageModule);
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    _getMessage();
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
      body: Stack(
        children: [
          ListView(
            padding:
                EdgeInsets.only(bottom: _showRecording ? 270 : 120, top: 10),
            reverse: true,
            controller: _scrollController,
            children: [
              Visibility(visible: _aiIsWriting, child: const AIWriting()),
              ChatMessagesList(messages: _newMessages),
              ChatMessagesList(messages: _savedChatMessage),
            ],
          ),
        ],
      ),
      bottomSheet: GetBuilder<SettingsController>(builder: (themeController) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          onEnd: () {
            setState(() {
              _showRecording = _isRecording;
            });
          },
          height: _isRecording ? 250 : null,
          constraints: const BoxConstraints(maxHeight: 300, minHeight: 80),
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
                  onPressImage: () {},
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
