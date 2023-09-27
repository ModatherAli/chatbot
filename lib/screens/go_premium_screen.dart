import 'dart:developer';

import 'package:ai/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:page_transition/page_transition.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controller/purchases_controller.dart';
import '../controller/theme_controller.dart';
import '../services/ads/ads_services.dart';
import '../services/api/purchases_api.dart';
import 'chat_screen.dart';
import 'widgets/or_divider.dart';
import 'widgets/widgets.dart';

enum PaymentPackage {
  weekly,
  monthly,
  yearly,
}

class GoPremiumScreen extends StatefulWidget {
  const GoPremiumScreen({super.key});

  @override
  State<GoPremiumScreen> createState() => _GoPremiumScreenState();
}

class _GoPremiumScreenState extends State<GoPremiumScreen> {
  PaymentPackage _paymentPackage = PaymentPackage.yearly;
  final PurchasesController _purchasesController = Get.find();
  final AdsServices _adsServices = AdsServices();
  final ThemeController _themeController = Get.find();
  final String _policyLink = 'https://229877.hostmypolicy.com';
  Package? _weeklyPackage;
  Package? _monthlyPackage;
  Package? _yearlyPackage;

  _lunchUrl(String link) async {
    Uri url = Uri.parse(link);
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  _changePaymentPackage(PaymentPackage paymentPackage) {
    setState(() {
      _paymentPackage = paymentPackage;
    });
  }

  _purchasePackage() async {
    bool result = false;

    switch (_paymentPackage) {
      case PaymentPackage.weekly:
        if (_weeklyPackage != null) {
          result = await PurchasesAPI.purchasePackage(_weeklyPackage!);
        }
        break;
      case PaymentPackage.monthly:
        result = await PurchasesAPI.purchasePackage(_monthlyPackage!);
        break;
      case PaymentPackage.yearly:
        result = await PurchasesAPI.purchasePackage(_yearlyPackage!);
        break;
    }
    if (result) {
      Get.offAll(() => const ChatScreen());
    }
  }

  _setPackages() {
    for (var package in _purchasesController.packages) {
      log(package.toJson().toString() + '\n');
      if (package.storeProduct.subscriptionPeriod!.contains('P1W')) {
        _weeklyPackage = package;
      } else if (package.storeProduct.subscriptionPeriod!.contains('P1M')) {
        _monthlyPackage = package;
      } else if (package.storeProduct.subscriptionPeriod!.contains('P1Y')) {
        _yearlyPackage = package;
      }
    }
    // _weeklyPackage = _purchasesController.packages
    //     .where((package) => package.identifier.contains('weekly'))
    //     .first;
    // _monthlyPackage = _purchasesController.packages
    //     .where((package) => package.identifier.contains('monthly'))
    //     .first;
    // _yearlyPackage = _purchasesController.packages
    //     .where((package) => package.identifier.contains('yearly'))
    //     .first;
  }

  @override
  void initState() {
    _setPackages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Navigator.canPop(context)
            ? const CloseButton()
            : CloseButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          type: PageTransitionType.fade,
                          child: const ChatScreen()));
                },
              ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_adsServices.rewardedAd != null) {
                      _adsServices.rewardedAd!.show(onUserEarnedReward:
                          (AdWithoutView ad, RewardItem rewardItem) async {
                        await _themeController.getMoreFreeMessageCounter();
                        Get.offAll(() => const ChatScreen());
                      });
                    } else {
                      await _adsServices.loadRewardedAd();
                      _adsServices.rewardedAd!.show(onUserEarnedReward:
                          (AdWithoutView ad, RewardItem rewardItem) async {
                        await _themeController.getMoreFreeMessageCounter();
                        Get.offAll(() => const ChatScreen());
                      });
                    }
                  },
                  child: Text(
                    'Watch Ad to get more free messages'.tr,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const OrDivider(),
              Row(
                children: [
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Row(
                      children: [
                        const Text(
                          'CHATE GPT',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(7),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFFffbe0b),
                                Color(0xFFffb703),
                                Color(0xFFfb8500),
                                // Color(0xFF),
                              ],
                            ),
                          ),
                          child: const Text(
                            'PRO',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'UNLOCK \nFULL ACCESS'.tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 40,
                  ),
                ),
              ),
              _accessInfo('Voice Assistant'),
              _accessInfo('Unlimited answers'),
              _accessInfo('Up to 2000 words per answer'),
              _accessInfo('Up to 1000 words per prompt'),
              _accessInfo('Higher word limit'),
              Row(
                children: [
                  PaymentPackageCard(
                    title: 'WEEKLY',
                    desc: 'Per week\nAuto-renewable weekly',
                    package: _weeklyPackage,
                    //package: '',
                    isSelected: _paymentPackage == PaymentPackage.weekly,
                    onTap: () {
                      log(_purchasesController.packages.length.toString());
                      _changePaymentPackage(PaymentPackage.weekly);
                    },
                  ),
                  PaymentPackageCard(
                    package: _monthlyPackage,
                    title: 'MONTHLY',
                    desc: 'Per month\nAuto-renewable monthly',
                    isSelected: _paymentPackage == PaymentPackage.monthly,
                    onTap: () {
                      _changePaymentPackage(PaymentPackage.monthly);
                    },
                  ),
                  PaymentPackageCard(
                    package: _yearlyPackage,
                    title: 'YEARLY',
                    desc: 'Per year\nAuto-renewable yearly',
                    isSelected: _paymentPackage == PaymentPackage.yearly,
                    onTap: () {
                      _changePaymentPackage(PaymentPackage.yearly);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ShakeAnimation(
                child: Center(
                  child: Container(
                    alignment: Alignment.center,
                    width: Get.width - 40,
                    child: Theme(
                      data: ThemeData(),
                      child: ElevatedButton(
                        onPressed: _purchasePackage,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Constants.primaryColor,
                            padding: const EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(),
                            Text('CONTINUE'.tr),
                            const Icon(Icons.arrow_forward_ios),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        _lunchUrl(_policyLink);
                      },
                      child: Text(
                        'Terms of Use'.tr,
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _lunchUrl(_policyLink);
                      },
                      child: Text(
                        'Privacy Policy'.tr,
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _accessInfo(String info) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        children: [
          const Icon(
            Icons.done,
            color: Colors.green,
          ),
          const SizedBox(width: 10),
          Text(
            info.tr,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
