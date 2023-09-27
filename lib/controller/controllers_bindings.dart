import 'package:get/get.dart';

import 'chat_controller.dart';
import 'theme_controller.dart';

class ControllerBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(ChatController(), permanent: true);
    Get.put(SettingsController(), permanent: true);
  }
}
