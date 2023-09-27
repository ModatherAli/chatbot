import 'dart:developer';

import 'package:android_id/android_id.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchasesAPI {
  static const String _apiKey = 'goog_vYMlmMuhpjayJxUOjOZGaJWTbXT';

  static Future<String?> _getId() async {
    // return null;

    String? uniqueDeviceId = '';

    const androidIdPlugin = AndroidId();

    uniqueDeviceId = await androidIdPlugin.getId();

    log('===================================');
    log(uniqueDeviceId!);
    return uniqueDeviceId;
  }

  static Future init() async {
    String? deviceId = await _getId();
    print(deviceId);
    await Purchases.setLogLevel(LogLevel.debug);
    await Purchases.configure(
        PurchasesConfiguration(_apiKey)..appUserID = '$deviceId');
  }

  Future<List<Offering>> fetchOffers() async {
    try {
      final offering = await Purchases.getOfferings();
      final current = offering.current;
      return current == null ? [] : [current];
    } on PlatformException catch (e) {
      log('error in fetchOffers : $e');
      return [];
    }
  }

  Future<List<Package>> fetchPackages() async {
    final List<Offering> offerings = await fetchOffers();

    List<Package> packages;
    if (offerings.isEmpty) {
      log('no offerings ');
      return [];
    } else {
      log('offerings : $offerings');
      packages = offerings
          .map((offer) => offer.availablePackages)
          .expand((pair) => pair)
          .toList();
      return packages;
    }
  }

  static Future<bool> purchasePackage(Package package) async {
    try {
      CustomerInfo customerInfo = await Purchases.purchasePackage(package);
      log(customerInfo.activeSubscriptions.toString());
      return true;
    } catch (e) {
      log('error in purchasePackage: $e');
      if (e
          .toString()
          .contains('This product is already active for the user')) {
        return true;
      }
      return false;
    }
  }
}
