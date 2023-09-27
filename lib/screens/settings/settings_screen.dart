import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share_plus/share_plus.dart';

import '../../helper/helper_services.dart';
import '../../res/constants.dart';
import '../widgets/widgets.dart';
import 'local_screen.dart';
import 'theme_screen.dart';
import 'voice_assistant.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final String _playStoreLink =
      'https://play.google.com/store/apps/details?id=${Constants.appID}';
  final String _policyLink = 'https://229877.hostmypolicy.com';

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
          WidgetsCollection(
            title: 'general',
            children: [
              MyListTile(
                onTap: () {
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
                  HelperServices.lunchUrl(_playStoreLink);
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
                      HelperServices.lunchUrl(_policyLink);
                    },
                    iconData: Icons.menu_book,
                  ),
                  MyListTile(
                    onTap: () {
                      HelperServices.lunchUrl(_policyLink);
                    },
                    title: 'Privacy Policy'.tr,
                    iconData: Icons.privacy_tip,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text('Powered by GPT technology'),
            ],
          ),
        ],
      ),
    );
  }
}
