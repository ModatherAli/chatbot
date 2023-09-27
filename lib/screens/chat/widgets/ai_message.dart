import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/theme_controller.dart';
import 'message _widget.dart';

class AIMessage extends StatelessWidget {
  const AIMessage({
    super.key,
    required this.message,
  });
  final String message;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(builder: (settingsController) {
      return MessageWidget(
          text: message,
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
