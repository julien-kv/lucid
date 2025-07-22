import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SigninController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxBool isLoading = false.obs;

  void onSignInPressed() async {
    // Simple validation
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
      return;
    }

    isLoading.value = true;

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    isLoading.value = false;

    // Navigate to home screen
    Get.offAllNamed('/home');
  }

  void onBackPressed() {
    Get.back();
  }

  void onForgotPasswordPressed() {
    // TODO: Implement forgot password functionality
    Get.snackbar(
      'Forgot Password',
      'Feature coming soon!',
      snackPosition: SnackPosition.TOP,
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
