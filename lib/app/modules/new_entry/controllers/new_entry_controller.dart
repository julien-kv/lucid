import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/models/journal_entry.dart';
import '../../../data/models/mood.dart';

class NewEntryController extends GetxController {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final Rx<Mood> selectedMood = Mood.neutral.obs;
  final RxList<String> attachments = <String>[].obs;
  final RxBool isSaving = false.obs;

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void onClose() {
    titleController.dispose();
    contentController.dispose();
    super.onClose();
  }

  void selectMood(Mood mood) {
    selectedMood.value = mood;
  }

  Future<void> addPhoto() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        attachments.add(image.path);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> addAudio() async {
    // For now, we'll just simulate adding an audio file
    // In a real app, you'd use a plugin like flutter_sound or audio_recorder
    Get.snackbar(
      'Audio Recording',
      'Audio recording feature coming soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void removeAttachment(int index) {
    if (index < attachments.length) {
      attachments.removeAt(index);
    }
  }

  Future<void> saveEntry() async {
    if (titleController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a title for your journal entry',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (contentController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please write some content for your journal entry',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isSaving.value = true;

    try {
      final now = DateTime.now();
      final newEntry = JournalEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: titleController.text.trim(),
        content: contentController.text.trim(),
        mood: selectedMood.value,
        createdAt: now,
        updatedAt: now,
        attachments: List.from(attachments),
      );

      // Here you would typically save to a database or API
      // For now, we'll just simulate a delay and show success
      await Future.delayed(const Duration(seconds: 1));

      Get.snackbar(
        'Success',
        'Journal entry saved successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigate back to journals
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save journal entry: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSaving.value = false;
    }
  }

  bool get canSave {
    return titleController.text.trim().isNotEmpty && contentController.text.trim().isNotEmpty;
  }
}
