import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/controller.dart';
import '../../../modules/message.dart';
import 'message _widget.dart';

class AIMessage extends StatefulWidget {
  AIMessage({
    super.key,
    required this.message,
    required this.lastMessage,
  });
  final Message message;

  final bool lastMessage;

  @override
  State<AIMessage> createState() => _AIMessageState();
}

class _AIMessageState extends State<AIMessage> {
  bool _isTyping = true;
  SettingsController _settingsController = Get.find();
  @override
  Widget build(BuildContext context) {
    //  return GetBuilder<SettingsController>(builder: (settingsController) {
    return GetBuilder<ChatController>(builder: (chatController) {
      return MessageWidget(
          message: widget.message,
          content: Visibility(
            visible:
                widget.lastMessage && _isTyping && chatController.isNewMessage,
            child: AnimatedTextKit(
                onFinished: () {
                  print('Finished');
                  chatController.isNewMessage = false;
                  _isTyping = false;
                  // setState(() => _isTyping = false);
                  chatController.update();
                },
                onTap: () {
                  chatController.isNewMessage = false;
                  _isTyping = false;
                  chatController.update();
                  // setState(() => _isTyping = false);
                },
                displayFullTextOnTap: true,
                totalRepeatCount: 1,
                animatedTexts: [
                  TypewriterAnimatedText(
                    widget.message.content,
                    textStyle: TextStyle(fontSize: 14.5),
                    speed: const Duration(milliseconds: 50),
                  ),
                ]),
            replacement: Text(
              widget.message.content,
              style: TextStyle(fontSize: 15),
            ),
          ),
          alignment: MainAxisAlignment.start,
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.only(
            topRight: _settingsController.appLocal == 'en'
                ? const Radius.circular(15)
                : Radius.zero,
            topLeft: _settingsController.appLocal != 'en'
                ? const Radius.circular(15)
                : Radius.zero,
          ));
    });
//    });
  }
}
