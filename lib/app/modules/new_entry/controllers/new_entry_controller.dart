import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/exceptions/api_exceptions.dart';
import '../../../data/models/mood.dart';
import '../../../data/services/journal_service.dart';
import '../../journals/controllers/journals_controller.dart';

class NewEntryController extends GetxController {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final Rx<Mood> selectedMood = Mood.neutral.obs;
  final RxList<String> attachments = <String>[].obs;
  final RxBool isSaving = false.obs;

  final ImagePicker _imagePicker = ImagePicker();
  final JournalService _journalService = Get.find<JournalService>();

  @override
  void onInit() {
    super.onInit();

    // Check if a prompt was passed from the prompts page
    final arguments = Get.arguments;
    if (arguments != null && arguments is Map<String, dynamic>) {
      final prompt = arguments['prompt'];
      if (prompt != null) {
        // Pre-fill content with the prompt
        contentController.text = '${prompt.title}\n\n';
      }
    }
  }

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
      // Convert mood enum to string
      final moodString = _mapMoodToString(selectedMood.value);

      // Create journal via API
      await _journalService.createJournal(
        title: titleController.text.trim(),
        content: contentController.text.trim(),
        mood: moodString,
        images: attachments.isNotEmpty ? attachments : null,
      );

      // Refresh journals list if controller exists
      try {
        final journalsController = Get.find<JournalsController>();
        journalsController.refreshJournals();
      } catch (e) {
        // Journals controller not found, that's okay
      }

      // Navigate back to journals
      Get.back();
      Get.snackbar(
        'Success',
        'Journal entry saved successfully!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withValues(alpha: 0.1),
        colorText: Colors.green,
      );
    } on ValidationException catch (e) {
      Get.snackbar(
        'Validation Error',
        e.message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange.withValues(alpha: 0.1),
        colorText: Colors.orange,
      );
    } on NetworkException {
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
        'Failed to save journal: ${e.message}',
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
      isSaving.value = false;
    }
  }

  String _mapMoodToString(Mood mood) {
    switch (mood) {
      case Mood.happy:
        return 'happy';
      case Mood.sad:
        return 'sad';
      case Mood.angry:
        return 'angry';
      case Mood.anxious:
        return 'anxious';
      case Mood.neutral:
        return 'neutral';
    }
  }

  bool get canSave {
    return titleController.text.trim().isNotEmpty && contentController.text.trim().isNotEmpty;
  }
}
