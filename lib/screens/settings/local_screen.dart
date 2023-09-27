import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/theme_controller.dart';
import '../chat/chat_screen.dart';
import '../widgets/widgets.dart';

class LocalScreen extends StatefulWidget {
  const LocalScreen({super.key});

  @override
  State<LocalScreen> createState() => _LocalScreenState();
}

class _LocalScreenState extends State<LocalScreen> {
  bool _isEn = true;
  String _local = 'ar';
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
        leading: Visibility(
          visible: _themeController.isLocalNull,
          child: CloseButton(
            onPressed: () {
              _themeController.changeLang(_local);
              Get.offAll(() => const ChatScreen());
            },
          ),
        ),
      ),
      body: Column(
        children: [
          SelectableListTile(
            title: 'English',
            isActive: _isEn,
            onTap: () async {
              _isEn = true;
              _local = 'en';
              await _themeController.changeLang('en');
              setState(() {});
            },
          ),
          SelectableListTile(
            title: 'عربي',
            isActive: !_isEn,
            onTap: () async {
              _isEn = false;
              _local = 'ar';
              await _themeController.changeLang('ar');
              setState(() {});
            },
          ),
          const SizedBox(height: 25),
          Visibility(
            visible: _themeController.isLocalNull,
            child: ElevatedButton.icon(
              onPressed: () {
                _themeController.changeLang(_local);
                Get.offAll(() => const ChatScreen());
              },
              icon: const Icon(Icons.login),
              label: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text('CONTINUE'.tr),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
