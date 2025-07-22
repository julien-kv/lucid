import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MicrojournalController extends GetxController {
  final RxString selectedMoodEmoji = '😐'.obs;
  final thoughtsController = TextEditingController();
  final RxBool isSaving = false.obs;

  final List<String> moodEmojis = ['🙁', '😐', '😊'];

  @override
  void onClose() {
    thoughtsController.dispose();
    super.onClose();
  }

  void selectMood(String emoji) {
    selectedMoodEmoji.value = emoji;
  }

  Future<void> saveEntry() async {
    if (thoughtsController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please add a few words about how you\'re feeling',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isSaving.value = true;

    try {
      // Simulate saving the microjournal entry
      await Future.delayed(const Duration(seconds: 1));

      Get.snackbar(
        'Success',
        'Your quick entry has been saved!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Clear the form
      selectedMoodEmoji.value = '😐';
      thoughtsController.clear();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save entry: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSaving.value = false;
    }
  }

  bool get canSave {
    return thoughtsController.text.trim().isNotEmpty;
  }
}
