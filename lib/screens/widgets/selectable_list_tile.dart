import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/settings_controller.dart';

class SelectableListTile extends StatelessWidget {
  const SelectableListTile(
      {super.key, required this.title, required this.isActive, this.onTap});

  final String title;
  final bool isActive;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(builder: (themeController) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          onTap: onTap,
          // selected: isActive,
          tileColor: Theme.of(context).cardColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Text(title.tr),
          trailing: Visibility(
            visible: isActive,
            child: const Icon(
              Icons.done,
              color: Colors.green,
            ),
          ),
        ),
      );
    });
  }
}
