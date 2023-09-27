import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/theme_controller.dart';
import '../../modules/message.dart';
import '../../res/constants.dart';
import 'dropdown_options.dart';

class UserMessage extends StatelessWidget {
  const UserMessage({super.key, required this.messageModule});
  final Message messageModule;
  @override
  Widget build(BuildContext context) {
    return DropdownOptions(
      messageModule: messageModule,
      child: GetBuilder<SettingsController>(builder: (themeController) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.all(15),
              constraints: BoxConstraints(
                maxWidth: Get.width * 0.85,
              ),
              decoration: BoxDecoration(
                color: Constants.primaryColor,
                borderRadius: BorderRadius.only(
                  topRight: themeController.appLocal != 'en'
                      ? const Radius.circular(15)
                      : Radius.zero,
                  topLeft: themeController.appLocal == 'en'
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
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
