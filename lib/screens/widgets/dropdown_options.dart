import 'package:flutter/material.dart';

import '../../../../../../packages.dart';

class DropdownOptions extends StatelessWidget {
  final Widget? child;
  final List<DropMenuItem> items;
  final double width;
  const DropdownOptions({
    super.key,
    this.child,
    required this.items,
    this.width = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          customButton: Center(child: child ?? const Icon(Icons.more_vert)),
          items: List.generate(
            items.length,
            (index) => DropdownMenuItem(
              value: index,
              child: Row(
                children: [
                  Icon(
                    items[index].icon,
                    size: 20,
                    color: items[index].color ?? Colors.grey,
                  ),
                  const SizedBox(width: 10),
                  AutoSizeText(
                    items[index].text.tr,
                    maxLines: 1,
                  ),
                  const Spacer(),
                  if (items[index].trailing != null) items[index].trailing!
                ],
              ),
            ),
          ),
          onChanged: (value) {
            items[value as int].onTap();
          },
          dropdownStyleData: DropdownStyleData(
            width: width,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
            ),
            elevation: 8,
          ),
          menuItemStyleData: const MenuItemStyleData(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: 40,
          ),
        ),
      ),
    );
  }
}

class DropMenuItem {
  final String text;
  final IconData icon;
  final Color? color;
  final Widget? trailing;
  final void Function() onTap;
  const DropMenuItem({
    required this.text,
    required this.icon,
    required this.onTap,
    this.trailing,
    this.color,
  });
}
