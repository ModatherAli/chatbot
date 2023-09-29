import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/settings_controller.dart';
import '../../../modules/message.dart';
import 'widgets.dart';

class UserMessage extends StatelessWidget {
  const UserMessage({super.key, required this.message});
  final Message message;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(builder: (settingsController) {
      return MessageWidget(
          message: message,
          textColor: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: settingsController.appLocal != 'en'
                ? const Radius.circular(15)
                : Radius.zero,
            topLeft: settingsController.appLocal == 'en'
                ? const Radius.circular(15)
                : Radius.zero,
          ));
    });
  }
}
