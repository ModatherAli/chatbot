import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../../controller/chat_controller.dart';
import '../../../controller/settings_controller.dart';
import '../../../modules/message.dart';
import '../../../res/constants.dart';
import '../../widgets/dropdown_options.dart';

// ignore: must_be_immutable
class MessageWidget extends StatelessWidget {
  final Message message;
  final MainAxisAlignment alignment;
  final Color color;
  final Color? textColor;
  final BorderRadius borderRadius;
  final bool animatedText;
  MessageWidget({
    super.key,
    this.alignment = MainAxisAlignment.end,
    this.color = Constants.primaryColor,
    this.textColor,
    required this.borderRadius,
    this.animatedText = false,
    required this.message,
  });
  ChatController _chatController = Get.find();
  @override
  Widget build(BuildContext context) {
    final String text = message.content.toString();
    return DropdownOptions(
      items: [
        DropMenuItem(
          text: 'Copy',
          icon: Icons.copy,
          onTap: () {
            Clipboard.setData(ClipboardData(text: text));
          },
        ),
        DropMenuItem(
          text: 'Share',
          icon: Icons.ios_share,
          onTap: () {
            Share.share(text);
          },
        ),
        DropMenuItem(
          text: 'Delete',
          icon: Icons.delete_forever_rounded,
          onTap: () {
            _chatController.deleteMessage(message);
          },
        ),
      ],
      child: GetBuilder<SettingsController>(builder: (themeController) {
        return Row(
          mainAxisAlignment: alignment,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.all(10),
              constraints: BoxConstraints(
                maxWidth: Get.width * 0.85,
              ),
              decoration: BoxDecoration(
                color: color,
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(15)) +
                        borderRadius,
              ),
              child: Visibility(
                visible: animatedText,
                child: AnimatedTextKit(
                    onFinished: () {
                      print('Finished');
                    },
                    displayFullTextOnTap: true,
                    totalRepeatCount: 1,
                    animatedTexts: [
                      TypewriterAnimatedText(
                        text,
                        textStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                        speed: const Duration(milliseconds: 100),
                      ),
                    ]),
                replacement: Text(
                  text,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
