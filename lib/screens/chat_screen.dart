import 'dart:async';
import 'dart:developer';

import 'package:ai/constants.dart';
import 'package:chat_gpt_flutter/chat_gpt_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:page_transition/page_transition.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../controller/purchases_controller.dart';
import '../services/ads/ads_services.dart';
import '../services/api/openai_api.dart';
import '../controller/message_controller.dart';
import '../controller/theme_controller.dart';
import '../modules/message_module.dart';
import 'go_premium_screen.dart';
import 'settings_screen.dart';
import 'widgets/image_message.dart';
import 'widgets/widgets.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final PurchasesController _purchasesController = Get.find();
  final MessageController _messageController =
      Get.put(MessageController(), permanent: true);
  final OpenAiAPI _openAiAPI = OpenAiAPI();
  final SpeechToText _speechToText = SpeechToText();
  final AdsServices _adsServices = AdsServices();
  final List<MessageModule> _chatMessage = [];
  final List<MessageModule> _savedChatMessage = [];
  ScrollController _scrollController = ScrollController();
  bool _aiIsWriting = false;
  bool _isRecording = false;
  bool _showRecording = false;
  bool _speechEnabled = false;
  bool _speechInit = false;
  String _lastWords = '';
  final ThemeController _themeController = Get.find();

  final ChatGpt chatGpt =
      ChatGpt(apiKey: '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');
  StreamSubscription<CompletionResponse>? streamSubscription;
  StreamSubscription<StreamCompletionResponse>? chatStreamSubscription;

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
    _themeController.updateFreeMessageCounter();
    setState(() {
      _aiIsWriting = false;
    });
  }

  _receiveMessage(String msg, bool isImage) async {
    MessageModule messageModule;
    Map<String, dynamic> response =
        await _openAiAPI.sendMessage(messageText: msg, wantsImage: isImage);

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
    final testRequest = ChatCompletionRequest(
      stream: true,
      maxTokens: 4000,
      messages: [Message(role: Role.user.name, content: msg)],
      model: ChatGptModel.gpt4,
    );
    await _chatStreamResponse(testRequest);
  }

  _chatStreamResponse(ChatCompletionRequest request) async {
    chatStreamSubscription?.cancel();
    try {
      final stream = await chatGpt.createChatCompletionStream(request);
      chatStreamSubscription = stream?.listen(
        (event) => setState(
          () {
            if (event.streamMessageEnd) {
              chatStreamSubscription?.cancel();
              _messageController.insertQRDate(
                message: _chatMessage.last.message.toString().trim(),
                isAI: 1,
                isImage: 0,
              );
              setState(() {});
            } else {
              setState(() {});
              _chatMessage.last.message.write(
                event.choices?.first.delta?.content,
              );
            }
          },
        ),
      );
    } catch (error) {
      setState(() {
        _chatMessage.last.message.write("Error");
      });
      log("Error occurred: $error");
    }
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

  _loadAds() async {
    await _purchasesController.init();
    if (!_purchasesController.isVIP) {
      await _adsServices.loadBannerAd();
      await _adsServices.loadNativeAd();
      await _adsServices.loadRewardedAd();
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    _loadAds();
    _getMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Chate GPT 👋'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              _isRecording = false;
              _showRecording = false;
              setState(() {});
              _adsServices.loadInterstitialAd();
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
                    if (_chatMessage[index].isImage) {
                      return ImageMessage(
                        messageModule: _chatMessage[index],
                      );
                    }
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
                    if (_savedChatMessage[index].isImage) {
                      return ImageMessage(
                        messageModule: _savedChatMessage[index],
                      );
                    }
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
          if (_adsServices.bannerAd != null)
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: Get.width,
                height: _adsServices.bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _adsServices.bannerAd!),
              ),
            ),
        ],
      ),
      bottomSheet: GetBuilder<ThemeController>(builder: (themeController) {
        // _showRecording = _isRecording;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          onEnd: () {
            setState(() {
              _showRecording = _isRecording;
            });
          },
          color: themeController.isDark
              ? Constants.primaryDarkColor
              : Colors.grey.shade100,
          height: _isRecording ? 250 : null,
          constraints: BoxConstraints(maxHeight: 300, minHeight: 80),
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
                  Visibility(
                    visible: _purchasesController.isVIP,
                    replacement: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "You have ${themeController.freeMessagesCunter} free message left. "
                                .tr,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.bottomToTop,
                                      child: const GoPremiumScreen()));
                            },
                            child: Text(
                              "Go Premium".tr,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Constants.primaryColor,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    child: const SizedBox(
                      height: 0,
                      width: 0,
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(maxHeight: 150),
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
                        if (_purchasesController.isVIP) {
                          await _sendMessage(_textController.text);
                        } else if (themeController.freeMessagesCunter <= 0) {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.bottomToTop,
                                  child: const GoPremiumScreen()));
                        } else {
                          await _sendMessage(_textController.text);
                        }
                      },
                      onPressImage: () async {
                        if (_purchasesController.isVIP) {
                          if (themeController.local == 'ar') {
                            if (themeController.isFirstImage) {
                              Get.snackbar(
                                'تنبيه',
                                'للحصول على صور بدقة افضل يرجى كتابة الوصف باللغة الإنجليزية',
                                backgroundColor: Colors.orange,
                                colorText: Colors.white,
                                duration: Duration(seconds: 30),
                              );
                              themeController.updateImage();
                            }
                          }

                          await _sendMessage(_textController.text,
                              isImage: true);
                        } else if (themeController.freeMessagesCunter <= 0) {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.bottomToTop,
                                  child: const GoPremiumScreen()));
                        } else {
                          if (themeController.local == 'ar') {
                            if (themeController.isFirstImage) {
                              Get.snackbar(
                                'تنبيه',
                                'للحصول على صور بدقة افضل يرجى كتابة الوصف باللغة الإنجليزية',
                                backgroundColor: Colors.orange,
                                colorText: Colors.white,
                                duration: Duration(seconds: 30),
                              );
                              themeController.updateImage();
                            }
                          }
                          await _sendMessage(_textController.text,
                              isImage: true);
                        }
                      },
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
                  if (_purchasesController.isVIP) {
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
                  } else if (themeController.freeMessagesCunter <= 0) {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.bottomToTop,
                            child: const GoPremiumScreen()));
                  } else {
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
                  }
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
