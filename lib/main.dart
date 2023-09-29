import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'controller/controllers_bindings.dart';
import 'controller/settings_controller.dart';
import 'res/app_locale.dart';
import 'res/app_theme.dart';
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
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

  _setServices() async {
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
        title: 'AI ChatBot',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: _settingsController.getThemeMode(),
        initialBinding: ControllerBindings(),
        locale: Locale(_settingsController.appLocal),
        translations: AppLocale(),
        home: AnimatedScreen(),
        builder: EasyLoading.init(),
      );
    });
  }
}
