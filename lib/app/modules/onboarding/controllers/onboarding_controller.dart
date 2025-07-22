import 'package:get/get.dart';

class OnboardingController extends GetxController {
  void onGetStartedPressed() {
    // Navigate to sign in screen
    Get.offNamed('/signin');
  }
}
