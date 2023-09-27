import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../modules/message_module.dart';

class DropdownOptions extends StatelessWidget {
  const DropdownOptions(
      {super.key, required this.child, required this.messageModule});
  final Widget child;
  final MessageModule messageModule;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          buttonStyleData: const ButtonStyleData(
            // padding: EdgeInsets.symmetric(horizontal: 60),
            elevation: 0,
          ),
          customButton: child,
          items: [
            ...MenuItems.firstItems.map(
              (item) => DropdownMenuItem<MenuItem>(
                value: item,
                child: MenuItems.buildItem(item),
              ),
            ),
          ],
          onChanged: (value) {
            MenuItems.onChanged(context, value as MenuItem,
                messageModule.message.toString().trim());
          },
          dropdownStyleData: DropdownStyleData(
            width: 160,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              // color: Colors.redAccent,
            ),
            elevation: 8,
            offset: const Offset(0, 8),
          ),
          menuItemStyleData: MenuItemStyleData(
            customHeights: [
              ...List<double>.filled(MenuItems.firstItems.length, 48),
            ],
            padding: const EdgeInsets.only(left: 16, right: 16),
          ),
        ),
      ),
    );
  }
}

class MenuItem {
  final String text;
  final IconData icon;

  const MenuItem({
    required this.text,
    required this.icon,
  });
}

class MenuItems {
  static const List<MenuItem> firstItems = [copy, share];
  // static const List<MenuItem> secondItems = [];

  static const copy = MenuItem(text: 'Copy', icon: Icons.copy);
  static const share = MenuItem(text: 'Share', icon: Icons.ios_share);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, size: 22),
        const SizedBox(
          width: 10,
        ),
        Text(
          item.text.tr,
          style: const TextStyle(
              // color: Colors.white,
              ),
        ),
      ],
    );
  }

  static onChanged(BuildContext context, MenuItem item, String text) async {
    switch (item) {
      case MenuItems.copy:
        Clipboard.setData(ClipboardData(text: text));
        break;
      case MenuItems.share:
        await Share.share(text);
        break;
    }
  }
}
