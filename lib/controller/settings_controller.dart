import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  late SharedPreferences _sharedPreferences;
  bool? isDark;
  String appLocal = 'ar';
  String voiceLocal = 'ar';

  Future init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    isDark = _sharedPreferences.getBool('theme_mode');
    _getAppLocal();
    update();
  }

  _getAppLocal() async {
    String? localCode = _sharedPreferences.getString('app_local');
    if (localCode != null) {
      appLocal = localCode;
      // Logger.print(appLocal);
    } else if (Get.deviceLocale != null) {
      appLocal = Get.deviceLocale!.languageCode == 'ar' ? 'ar' : 'en';
    }
    voiceLocal = _sharedPreferences.getString('voice_local') ?? appLocal;
    update();
    await Get.updateLocale(Locale(appLocal));
  }

  Future changeLang(String langCode) async {
    Locale newLocale = Locale(langCode);
    appLocal = langCode;

    await _sharedPreferences.setString('app_local', langCode);
    await Get.updateLocale(newLocale);
    update();
  }

  Future changeVoiceLocal(String langCode) async {
    voiceLocal = langCode;
    await _sharedPreferences.setString('voice_local', langCode);
    update();
  }

  Future changeThemeMode(ThemeMode themeMode) async {
    switch (themeMode) {
      case ThemeMode.system:
        isDark = null;
        await _sharedPreferences.remove('theme_mode');
        break;
      case ThemeMode.dark:
        isDark = true;
        break;
      case ThemeMode.light:
        isDark = false;
        break;
      default:
    }

    Get.changeThemeMode(themeMode);
    if (isDark != null) {
      await _sharedPreferences.setBool('theme_mode', isDark!);
    }

    update();
  }

  ThemeMode getThemeMode() {
    switch (isDark) {
      case null:
        return ThemeMode.system;

      case true:
        return ThemeMode.dark;

      default:
        return ThemeMode.light;
    }
  }
}
