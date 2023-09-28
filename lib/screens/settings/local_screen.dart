import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/settings_controller.dart';
import '../widgets/widgets.dart';

class LocalScreen extends StatefulWidget {
  const LocalScreen({super.key});

  @override
  State<LocalScreen> createState() => _LocalScreenState();
}

class _LocalScreenState extends State<LocalScreen> {
  bool _isEn = true;
  final SettingsController _themeController =
      Get.put(SettingsController(), permanent: true);
  @override
  void initState() {
    _isEn = _themeController.appLocal == 'en';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Language'.tr.toUpperCase()),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SelectableListTile(
            title: 'English',
            isActive: _isEn,
            onTap: () async {
              _isEn = true;
              await _themeController.changeLang('en');
              setState(() {});
            },
          ),
          SelectableListTile(
            title: 'عربي',
            isActive: !_isEn,
            onTap: () async {
              _isEn = false;
              await _themeController.changeLang('ar');
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
