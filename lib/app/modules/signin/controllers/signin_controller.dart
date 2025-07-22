import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/exceptions/api_exceptions.dart';
import '../../../data/services/auth_service.dart';

class SigninController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final AuthService _authService = Get.find<AuthService>();

  void onSignInPressed() async {
    // Simple validation
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Call API login
      final loginResponse = await _authService.login(
        username: emailController.text.trim(),
        password: passwordController.text,
      );

      // Show success message
      Get.snackbar(
        'Success',
        'Welcome back, ${loginResponse.user.fullName}!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withValues(alpha: 0.1),
        colorText: Colors.green,
      );

      // Navigate to main screen
      Get.offAllNamed('/main');
    } on ValidationException catch (e) {
      Get.snackbar(
        'Validation Error',
        e.message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange.withValues(alpha: 0.1),
        colorText: Colors.orange,
      );
    } on UnauthorizedException catch (e) {
      Get.snackbar(
        'Login Failed',
        'Invalid username or password',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    } on NetworkException catch (e) {
      Get.snackbar(
        'Network Error',
        'Please check your internet connection',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blue.withValues(alpha: 0.1),
        colorText: Colors.blue,
      );
    } on ApiException catch (e) {
      Get.snackbar(
        'Error',
        e.message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
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
