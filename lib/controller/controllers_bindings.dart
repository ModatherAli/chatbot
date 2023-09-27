import 'package:get/get.dart';

import 'message_controller.dart';
import 'purchases_controller.dart';
import 'theme_controller.dart';

class ControllerBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(MessageController(), permanent: true);
    Get.put(PurchasesController(), permanent: true);
    Get.put(ThemeController(), permanent: true);
  }
}
