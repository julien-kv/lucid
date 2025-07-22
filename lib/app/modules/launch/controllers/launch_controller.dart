import 'package:get/get.dart';

class LaunchController extends GetxController {
  void onNextPressed() {
    // Navigate to welcome/onboarding screen
    Get.offNamed('/onboarding');
  }
}
