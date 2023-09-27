import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/theme_controller.dart';

class AIWriting extends StatefulWidget {
  const AIWriting({super.key});

  @override
  State<AIWriting> createState() => _AIWritingState();
}

class _AIWritingState extends State<AIWriting>
    with SingleTickerProviderStateMixin {
  String typingImage = '';
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(builder: (settingsController) {
      if (settingsController.getThemeMode() == ThemeMode.dark) {
        typingImage = 'assets/images/typing_dark.gif';
      } else {
        typingImage = 'assets/images/typing.gif';
      }
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.all(15),
            height: 40,
            width: 50,
            constraints: BoxConstraints(
              maxWidth: Get.width * 0.85,
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(typingImage),
                fit: BoxFit.cover,
              ),
              // color:
              //     settingsController.isDark ? Constants.darkColor : Colors.white,
              borderRadius: BorderRadius.only(
                topRight: settingsController.appLocal == 'en'
                    ? const Radius.circular(15)
                    : Radius.zero,
                topLeft: settingsController.appLocal != 'en'
                    ? const Radius.circular(15)
                    : Radius.zero,
                bottomLeft: const Radius.circular(15),
                bottomRight: const Radius.circular(15),
              ),
            ),
          ),
        ],
      );
    });
  }
}
