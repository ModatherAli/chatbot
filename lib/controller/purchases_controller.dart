import 'dart:developer';

import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../services/api/purchases_api.dart';

enum Entitlement {
  free,
  pro,
}

class PurchasesController extends GetxController {
  PurchasesController() {
    init();
  }
  final PurchasesAPI _purchasesAPI = PurchasesAPI();
  Entitlement _entitlement = Entitlement.free;
  List<Package> packages = [];
  Entitlement get entitlement => _entitlement;
  bool isVIP = false;
  Future init() async {
    Purchases.addCustomerInfoUpdateListener((customerInfo) async {
      log('======== ${customerInfo.activeSubscriptions}');
      // bool isActive = false;
      await updatePurchaseStatus(
        hasSubscription: customerInfo.activeSubscriptions.isNotEmpty,
      );
      print(_entitlement);
    });

    packages = await _purchasesAPI.fetchPackages();
    log(packages.length.toString());

    update();
  }

  Future updatePurchaseStatus({bool hasSubscription = false}) async {
    final purchaserInfo = await Purchases.getCustomerInfo();
    final entitlements = purchaserInfo.entitlements.active.values.toList();
    if (hasSubscription) {
      _entitlement = Entitlement.pro;
      isVIP = true;
      log(entitlements.toString());
    } else {
      _entitlement = entitlements.isEmpty ? Entitlement.free : Entitlement.pro;
      isVIP = entitlements.isNotEmpty;
    }
    update();
  }
}
