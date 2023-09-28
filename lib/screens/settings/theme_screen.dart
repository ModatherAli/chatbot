import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/settings_controller.dart';
import '../widgets/widgets.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({super.key});

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  final SettingsController _settingsController = Get.find();
  late ThemeMode _themeMode;
  @override
  void initState() {
    _themeMode = _settingsController.getThemeMode();
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
            isActive: _themeMode == ThemeMode.dark,
            onTap: () async {
              _updateTheme(ThemeMode.dark);
            },
          ),
          SelectableListTile(
            title: 'Off',
            isActive: _themeMode == ThemeMode.light,
            onTap: () async {
              _updateTheme(ThemeMode.light);
            },
          ),
          SelectableListTile(
            title: 'System',
            isActive: _themeMode == ThemeMode.system,
            onTap: () {
              _updateTheme(ThemeMode.system);
            },
          ),
        ],
      ),
    );
  }

  void _updateTheme(ThemeMode theme) async {
    _themeMode = theme;
    await _settingsController.changeThemeMode(_themeMode);
    setState(() {});
  }
}
