import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controller/controllers_bindings.dart';
import 'controller/theme_controller.dart';
import 'res/app_locale.dart';
import 'res/app_theme.dart';
import 'screens/chat_screen.dart';
import 'screens/settings/local_screen.dart';

late SharedPreferences sharedPreferences;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final SettingsController _settingsController =
      Get.put(SettingsController(), permanent: true);
  bool showSplash = true;
  // final InAppReview inAppReview = InAppReview.instance;

  // _appReview() async {
  //   if (await inAppReview.isAvailable()) {
  //     await inAppReview.requestReview();
  //   }
  // }

  _setServices() async {
    // _appReview();

    _settingsController.init();
    setState(() {});
  }

  @override
  void initState() {
    _setServices();
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(builder: (themeController) {
      return GetMaterialApp(
        title: 'Chatbot',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: _settingsController.getThemeMode(),
        initialBinding: ControllerBindings(),
        locale: Locale(_settingsController.appLocal),
        translations: AppLocale(),
        home: _settingsController.isLocalNull
            ? const LocalScreen()
            : const ChatScreen(),
        builder: EasyLoading.init(),
      );
    });
  }
}
