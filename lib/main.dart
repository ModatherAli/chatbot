import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controller/controllers_bindings.dart';
import 'controller/purchases_controller.dart';
import 'controller/theme_controller.dart';

import 'res/app_locale.dart';
import 'res/app_theme.dart';
import 'package:get/get.dart';

import 'screens/chat_screen.dart';
import 'screens/local_screen.dart';
import 'services/ads/ads_services.dart';
import 'services/api/purchases_api.dart';

late SharedPreferences sharedPreferences;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await PurchasesAPI.init();
  await MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeController _themeController =
      Get.put(ThemeController(), permanent: true);
  final PurchasesController _purchasesController =
      Get.put(PurchasesController(), permanent: true);
  final AdsServices _adsServices = AdsServices();
  bool showSplash = true;
  final InAppReview inAppReview = InAppReview.instance;

  _appReview() async {
    if (await inAppReview.isAvailable()) {
      await inAppReview.requestReview();
    }
  }

  _setServices() async {
    _appReview();
    await _purchasesController.init();
    if (!_purchasesController.isVIP) {
      await _adsServices.loadOpenAppAd();
    }
    setState(() {});
  }

  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        showSplash = false;
      });
    });
    _themeController.init();
    _setServices();
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(builder: (themeController) {
      return GetMaterialApp(
        title: 'Chate GPT',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: _themeController.isDark ? ThemeMode.dark : ThemeMode.light,
        initialBinding: ControllerBindings(),
        locale: Locale(_themeController.local),
        translations: AppLocale(),
        home: showSplash
            ? Scaffold(
                backgroundColor: Colors.white, //Color(0xFf286f55),
                body: SizedBox(
                  height: Get.height,
                  width: Get.width,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/icon.png",
                          height: 200, width: 200,
                        ),
                        SizedBox(height: 25),
                        Text(
                          'AI ChatBot 4',
                          style: Theme.of(context).textTheme.titleLarge,
                        )
                      ],
                    ),
                  ),
                ),
              )
            : _themeController.isLocalNull
                ? const LocalScreen()
                : const ChatScreen(),
        builder: EasyLoading.init(),
      );
    });
  }
}
