import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../res/app_theme.dart';

class ThemeController extends GetxController {
  bool isDark = false;
  bool isLocalNull = false;
  String local = 'ar';
  String voiceLocal = 'ar';
  int freeMessagesCunter = 0;
  bool isFirstImage = true;
  Future<ThemeController> init() async {
    // Get.deviceLocale
    isDark = sharedPreferences.getBool('theme_mode') ?? false;
    isFirstImage = sharedPreferences.getBool('is_first_image') ?? true;
    //     ThemeMode.system == ThemeMode.light
    // ? false
    // : true;
    if (sharedPreferences.getString('local') != null) {
      local = sharedPreferences.getString('local')!;
    } else {
      isLocalNull = true;
    }

    voiceLocal = sharedPreferences.getString('voice_local') ?? 'ar';
    freeMessagesCunter = sharedPreferences.getInt('free_msg') ?? 3;
    return this;
  }

  updateImage() {
    if (!isFirstImage) {
      isFirstImage = false;
      sharedPreferences.setBool('is_first_image', false);
      update();
    }
  }

  Future changeThemeMode(bool isDarkMode) async {
    if (isDarkMode) {
      Get.changeTheme(darkTheme);
    } else {
      Get.changeTheme(lightTheme);
    }
    isDark = isDarkMode;
    await sharedPreferences.setBool('theme_mode', isDarkMode);
    update();
  }

  Future changeLang(String langCode) async {
    Locale newLocale = Locale(langCode);
    local = langCode;
    await Get.updateLocale(newLocale);
    await sharedPreferences.setString('local', langCode);
    update();
  }

  Future changeVoiceLocal(String langCode) async {
    voiceLocal = langCode;
    await sharedPreferences.setString('voice_local', langCode);
    update();
  }

  updateFreeMessageCounter() {
    if (freeMessagesCunter > 0) {
      freeMessagesCunter--;
      sharedPreferences.setInt('free_msg', freeMessagesCunter);
    }
    update();
  }

  getMoreFreeMessageCounter() async {
    freeMessagesCunter += 3;
    await sharedPreferences.setInt('free_msg', freeMessagesCunter);

    update();
  }
}
