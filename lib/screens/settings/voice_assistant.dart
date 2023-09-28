import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/settings_controller.dart';
import '../widgets/selectable_list_tile.dart';

class VoiceAssistant extends StatefulWidget {
  const VoiceAssistant({super.key});

  @override
  State<VoiceAssistant> createState() => _VoiceAssistantState();
}

class _VoiceAssistantState extends State<VoiceAssistant> {
  final Map _langLocal = {
    'عربي': 'ar',
    'English': 'en',
    'English (India)': 'en_IN',
    'English (United States) ': 'en_US',
    'Deutsch': 'de',
    'español': 'es',
    'française': 'fr',
    'Italian': 'it',
    '日本語': 'ja',
    'Kikuyu': 'ki',
    'Türk Dili': 'tr',
    '中文': 'zh',
    'Українська мова': 'uk',
    'русский язык': 'ru',
  };
  final SettingsController _themeController =
      Get.put(SettingsController(), permanent: true);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voice Assistant'.tr),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          for (var lang in _langLocal.entries)
            SelectableListTile(
              title: lang.key,
              isActive: _themeController.voiceLocal == lang.value,
              onTap: () async {
                await _themeController.changeVoiceLocal(lang.value);
                setState(() {});
              },
            ),
        ],
      ),
    );
  }
}
