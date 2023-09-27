import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/theme_controller.dart';

class MyListTile extends StatelessWidget {
  const MyListTile({
    super.key,
    required this.title,
    required this.iconData,
    this.onTap,
  });
  final String title;
  final IconData iconData;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(builder: (themeController) {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ListTile(
          onTap: onTap,
          // tileColor:
          //     themeController.isDark ? Constants.darkColor : Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          leading: Icon(iconData),
          minLeadingWidth: 0,
          title: Text(title.tr),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 20,
          ),
        ),
      );
    });
  }
}
