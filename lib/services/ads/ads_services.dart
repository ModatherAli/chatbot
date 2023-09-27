import 'dart:developer';

import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../controller/purchases_controller.dart';
import 'ad_helper.dart';

class AdsServices {
  AppOpenAd? _appOpenAd;
  BannerAd? bannerAd;
  InterstitialAd? interstitialAd;
  NativeAd? nativeAd;
  RewardedAd? rewardedAd;
  final PurchasesController _purchasesController = Get.find();
  Future loadOpenAppAd() async {
    if (!_purchasesController.isVIP) {
      await AppOpenAd.load(
        adUnitId: AdHelper.openAppAdUnitId,
        orientation: AppOpenAd.orientationPortrait,
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            _appOpenAd = ad;

            if (_appOpenAd != null) {
              _appOpenAd!.show();
            }
          },
          onAdFailedToLoad: (error) {
            log('AppOpenAd failed to load: $error');
          },
        ),
      );
    }
  }

  loadBannerAd() async {
    if (!_purchasesController.isVIP) {
      await BannerAd(
        adUnitId: AdHelper.bannerAdUnitId,
        request: const AdRequest(),
        size: AdSize.banner,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            bannerAd = ad as BannerAd;
          },
          onAdFailedToLoad: (ad, err) {
            log('Failed to load a banner ad: ${err.message}');
            ad.dispose();
          },
        ),
      ).load();
    }
  }

  Future loadInterstitialAd() async {
    if (!_purchasesController.isVIP) {
      await InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            interstitialAd = ad;
            interstitialAd!.show();
          },
          onAdFailedToLoad: (err) {
            print('Failed to load an interstitial ad: ${err.message}');
          },
        ),
      );
    }
  }

  Future loadNativeAd() async {
    if (!_purchasesController.isVIP) {
      await NativeAd(
        request: const AdRequest(),
        adUnitId: AdHelper.nativeAdId,
        factoryId: 'listTile',
        listener: NativeAdListener(
          onAdFailedToLoad: (ad, error) {
            // ad.dispose();
            log('failed to load the ad ${error.message}, ${error.code}');
          },
          onAdLoaded: (ad) {
            log('n ad loaded');
            nativeAd = ad as NativeAd;
          },
        ),
      ).load();
    }
  }

  loadRewardedAd() async {
    await RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          log('$ad loaded.');
          // Keep a reference to the ad so you can show it later.
          rewardedAd = ad;
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (LoadAdError error) {
          log('RewardedAd failed to load: $error');
        },
      ),
    );
  }
}
