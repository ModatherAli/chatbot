import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/theme_controller.dart';
import 'widgets/widgets.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({super.key});

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  bool _isDark = true;

  final ThemeController _themeController =
      Get.put(ThemeController(), permanent: true);
  @override
  void initState() {
    _isDark = _themeController.isDark;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dark theme'.tr.toUpperCase()),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SelectableListTile(
            title: 'On',
            isActive: _isDark,
            onTap: () async {
              _isDark = true;

              await _themeController.changeThemeMode(_isDark);
              // _themeController.changeLang('ar');
              setState(() {});
            },
          ),
          SelectableListTile(
            title: 'Off',
            isActive: !_isDark,
            onTap: () async {
              _isDark = false;

              await _themeController.changeThemeMode(_isDark);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
