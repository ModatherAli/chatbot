import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../controller/message_controller.dart';
import '../controller/theme_controller.dart';
import '../modules/message_module.dart';
import '../packages.dart';
import 'settings/settings_screen.dart';
import 'widgets/widgets.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final MessageController _messageController =
      Get.put(MessageController(), permanent: true);

  final SpeechToText _speechToText = SpeechToText();
  final List<MessageModule> _chatMessage = [];
  final List<MessageModule> _savedChatMessage = [];
  final ScrollController _scrollController = ScrollController();
  bool _aiIsWriting = false;
  bool _isRecording = false;
  bool _showRecording = false;
  bool _speechEnabled = false;
  bool _speechInit = false;
  String _lastWords = '';
  final SettingsController _themeController = Get.find();

  Future _sendMessage(
    String msg, {
    bool isImage = false,
  }) async {
    MessageModule messageModule;
    StringBuffer stringBuffer = StringBuffer();
    stringBuffer.write(msg);
    messageModule = MessageModule(
      message: stringBuffer,
      isAI: false,
    );
    _scrollController.jumpTo(0);
    _chatMessage.add(messageModule);
    setState(() {
      _textController.clear();
      _aiIsWriting = true;
    });
    await _messageController.insertQRDate(message: msg);
    await _receiveMessage(msg, isImage);
    setState(() {
      _aiIsWriting = false;
    });
  }

  _receiveMessage(String msg, bool isImage) async {
    MessageModule messageModule;
    Map<String, dynamic> response = {};
    // await _openAiAPI.sendMessage(messageText: msg, wantsImage: isImage);

    StringBuffer stringBuffer = StringBuffer();

    if (isImage) {
      log(response['data'][0]['url']);
      stringBuffer.write(response['data'][0]['url']);
      messageModule = MessageModule(
        message: stringBuffer,
        isAI: true,
        isImage: true,
      );

      _chatMessage.add(messageModule);
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
    _chatMessage.add(
      MessageModule(
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
    MessageModule messageModule;

    StringBuffer stringBuffer = StringBuffer();
    stringBuffer.write('Hi. You can ask me anything'.tr);
    messageModule = MessageModule(
      isAI: true,
      message: stringBuffer,
    );
    _chatMessage.add(messageModule);
    setState(() {});
    await _messageController.readData();
    for (var message in _messageController.messages) {
      StringBuffer buffer = StringBuffer();
      buffer.write(message['message'].toString());
      if (message['is_ai'] == 1) {
        messageModule = MessageModule(
          isAI: true,
          isImage: message['is_image'] == 1,
          message: buffer,
        );
      } else {
        messageModule = MessageModule(
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
              ListView.builder(
                itemCount: _chatMessage.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  if (_chatMessage[index].isAI) {
                    return AIMessage(
                      messageModule: _chatMessage[index],
                    );
                  }
                  return UserMessage(
                    messageModule: _chatMessage[index],
                  );
                },
              ),
              ListView.builder(
                itemCount: _savedChatMessage.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  if (_savedChatMessage[index].isAI) {
                    return AIMessage(
                      messageModule: _savedChatMessage[index],
                    );
                  }
                  return UserMessage(
                    messageModule: _savedChatMessage[index],
                  );
                },
              ),
            ],
          ),
        ],
      ),
      bottomSheet: GetBuilder<SettingsController>(builder: (themeController) {
        // _showRecording = _isRecording;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          onEnd: () {
            setState(() {
              _showRecording = _isRecording;
            });
          },

          height: _isRecording ? 250 : null,
          constraints: const BoxConstraints(maxHeight: 300, minHeight: 80),
          //     : _purchasesController.isVIP
          //         ? 80
          //         : 130,
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Visibility(
              visible: _isRecording,
              replacement: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    constraints: const BoxConstraints(maxHeight: 150),
                    child: UserTextField(
                      textController: _textController,
                      onChanged: (value) {
                        setState(() {});
                      },
                      onMicPressed: () {
                        setState(() {
                          _isRecording = true;
                        });
                      },
                      onSendText: () async {
                        await _sendMessage(_textController.text);
                      },
                      onPressImage: () async {},
                    ),
                  ),
                ],
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
              )
              // : Container(
              //     color: themeController.isDark
              //         ? Constants.darkColor
              //         : Colors.white,
              //   ),
              ),
        );
      }),
    );
  }
}
