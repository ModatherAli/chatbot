import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../../controller/theme_controller.dart';
import '../../../res/constants.dart';
import '../../widgets/dropdown_options.dart';

class MessageWidget extends StatelessWidget {
  final String text;
  final MainAxisAlignment alignment;
  final Color color;
  final BorderRadius borderRadius;
  const MessageWidget({
    super.key,
    required this.text,
    this.alignment = MainAxisAlignment.end,
    this.color = Constants.primaryColor,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
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
              child: Text(
                text,
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
