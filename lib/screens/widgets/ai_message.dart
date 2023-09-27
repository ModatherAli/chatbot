import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/theme_controller.dart';
import '../../modules/message.dart';
import 'widgets.dart';

class AIMessage extends StatelessWidget {
  const AIMessage({
    super.key,
    required this.messageModule,
    // this.isTyping = true,
  });
  final Message messageModule;
  // final bool isTyping;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(builder: (themeController) {
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
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topRight: themeController.appLocal == 'en'
                      ? const Radius.circular(15)
                      : Radius.zero,
                  topLeft: themeController.appLocal != 'en'
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
