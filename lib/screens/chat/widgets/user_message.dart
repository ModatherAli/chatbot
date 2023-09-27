import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/theme_controller.dart';
import 'widgets.dart';
// import '../../widgets/dropdown_options.dart';

class UserMessage extends StatelessWidget {
  const UserMessage({super.key, required this.message});
  final String message;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(builder: (settingsController) {
      return MessageWidget(
          text: message,
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
