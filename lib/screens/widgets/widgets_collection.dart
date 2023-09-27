import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WidgetsCollection extends StatelessWidget {
  const WidgetsCollection(
      {super.key, required this.title, required this.children});
  final String title;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30, bottom: 5),
          child: Text(
            title.tr.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: children,
        )
      ],
    );
  }
}
