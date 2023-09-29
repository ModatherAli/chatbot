import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/settings_controller.dart';
import '../../../modules/message.dart';
import 'message _widget.dart';

class AIMessage extends StatelessWidget {
  const AIMessage({
    super.key,
    required this.message,
  });
  final Message message;

  // final bool animatedText;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(builder: (settingsController) {
      return MessageWidget(
          message: message,
          content: Visibility(
            visible: false,
            child: AnimatedTextKit(
                onFinished: () {
                  print('Finished');
                },
                displayFullTextOnTap: true,
                totalRepeatCount: 1,
                animatedTexts: [
                  TypewriterAnimatedText(
                    message.content,
                    textStyle: TextStyle(fontSize: 14.5),
                    speed: const Duration(milliseconds: 100),
                  ),
                ]),
            replacement: Text(
              message.content,
              style: TextStyle(fontSize: 15),
            ),
          ),
          alignment: MainAxisAlignment.start,
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.only(
            topRight: settingsController.appLocal == 'en'
                ? const Radius.circular(15)
                : Radius.zero,
            topLeft: settingsController.appLocal != 'en'
                ? const Radius.circular(15)
                : Radius.zero,
          ));
    });
  }
}
