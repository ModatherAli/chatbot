import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants.dart';
import '../../controller/theme_controller.dart';
import '../../modules/message_module.dart';
import 'dropdown_options.dart';

class UserMessage extends StatelessWidget {
  const UserMessage({super.key, required this.messageModule});
  final MessageModule messageModule;
  @override
  Widget build(BuildContext context) {
    return DropdownOptions(
      messageModule: messageModule,
      child: GetBuilder<ThemeController>(builder: (themeController) {
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
                  topRight: themeController.local != 'en'
                      ? const Radius.circular(15)
                      : Radius.zero,
                  topLeft: themeController.local == 'en'
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
