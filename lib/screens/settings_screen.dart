import 'package:ai/constants.dart';
import 'package:ai/screens/local_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controller/purchases_controller.dart';
import '../services/ads/ads_services.dart';
import 'go_premium_screen.dart';
import 'theme_screen.dart';
import 'voice_assistant.dart';
import 'widgets/widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AdsServices _adsServices = AdsServices();
  final PurchasesController _purchasesController = Get.find();
  final String _playStoreLink =
      'https://play.google.com/store/apps/details?id=${Constants.appID}';
  final String _policyLink = 'https://229877.hostmypolicy.com';

  _lunchUrl(String link) async {
    Uri url = Uri.parse(link);
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  void initState() {
    _adsServices.loadNativeAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SETTINGS'.tr),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          GestureDetector(
            onTap: () {
              if (!_purchasesController.isVIP) {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.bottomToTop,
                        child: const GoPremiumScreen()));
              }
            },
            child: Card(
              color: Constants.primaryColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  leading: const Icon(
                    Icons.diamond,
                    color: Colors.red,
                    size: 40,
                  ),
                  title: Text(
                    "Go Premium".tr,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    _purchasesController.isVIP
                        ? "Status: pro".tr
                        : "Status: Free".tr,
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
          WidgetsCollection(
            title: 'general',
            children: [
              MyListTile(
                onTap: () {
                  _adsServices.loadInterstitialAd();
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: const ThemeScreen()));
                },
                title: 'Dark theme',
                iconData: Icons.dark_mode,
              ),
              MyListTile(
                onTap: () {
                  _adsServices.loadInterstitialAd();
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: const LocalScreen()));
                },
                title: 'Language',
                iconData: Icons.translate,
              ),
              MyListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: const VoiceAssistant()));
                },
                title: 'Voice Assistant',
                iconData: Icons.mic,
              ),
            ],
          ),
          if (!_purchasesController.isVIP)
            TimerBuilder.periodic(
              const Duration(seconds: 1),
              builder: (context) {
                if (_adsServices.nativeAd != null) {
                  return Container(
                    margin: const EdgeInsets.only(top: 15),
                    alignment: Alignment.bottomCenter,
                    height: 150,
                    color: Colors.black12,
                    width: double.infinity,
                    child: AdWidget(
                      ad: _adsServices.nativeAd!,
                    ),
                  );
                } else {
                  return const SizedBox(height: 150);
                }
              },
            ),
          WidgetsCollection(
            title: 'customer service',
            children: [
              MyListTile(
                onTap: () async {
                  await Share.share(_playStoreLink);
                },
                title: 'Share',
                iconData: Icons.share,
              ),
              MyListTile(
                onTap: () async {
                  _lunchUrl(_playStoreLink);
                },
                title: 'Rate App',
                iconData: Icons.rate_review,
              ),
              const MyListTile(
                title: 'Contact us',
                iconData: Icons.contact_support,
              ),
              WidgetsCollection(
                title: 'policy',
                children: [
                  MyListTile(
                    title: 'Terms of Use'.tr,
                    onTap: () {
                      _lunchUrl(_policyLink);
                    },
                    iconData: Icons.menu_book,
                  ),
                  MyListTile(
                    onTap: () {
                      _lunchUrl(_policyLink);
                    },
                    title: 'Privacy Policy'.tr,
                    iconData: Icons.privacy_tip,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text('Powered by GPT technology'),
              const Text('Chate GPT ver: 1.0.0'),
            ],
          ),
        ],
      ),
    );
  }
}
