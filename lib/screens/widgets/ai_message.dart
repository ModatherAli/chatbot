import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../../controller/theme_controller.dart';
import '../../modules/message_module.dart';
import 'widgets.dart';

class AIMessage extends StatelessWidget {
  const AIMessage({
    super.key,
    required this.messageModule,
    // this.isTyping = true,
  });
  final MessageModule messageModule;
  // final bool isTyping;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(builder: (themeController) {
      return DropdownOptions(
        messageModule: messageModule,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              constraints: BoxConstraints(
                maxWidth: Get.width * 0.85,
              ),
              decoration: BoxDecoration(
                color:
                    themeController.isDark ? Constants.darkColor : Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: themeController.local == 'en'
                      ? const Radius.circular(15)
                      : Radius.zero,
                  topLeft: themeController.local != 'en'
                      ? const Radius.circular(15)
                      : Radius.zero,
                  bottomLeft: const Radius.circular(15),
                  bottomRight: const Radius.circular(15),
                ),
              ),
              child: Text(
                messageModule.message.toString().trim(),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
