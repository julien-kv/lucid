import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WeeklySummaryController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;

  final WeeklySummaryData summaryData = WeeklySummaryData(
    title: 'Your Week in Review',
    description:
        'This week, your journal entries painted a picture of resilience and growth. Here\'s a glimpse into your emotional landscape and key moments.',
    emotionalTheme: 'Emotional Theme: Serenity',
    emotionalDescription:
        'Your entries reflected a sense of calm and contentment, even amidst challenges.',
    keyMoments: [
      KeyMoment(
        day: 'Tuesday',
        description: 'Reflected on a meaningful conversation with a friend.',
      ),
      KeyMoment(
        day: 'Wednesday',
        description: 'Celebrated a small victory at work.',
      ),
      KeyMoment(
        day: 'Thursday',
        description: 'Took a relaxing walk in nature.',
      ),
    ],
    affirmation:
        '"I am capable of navigating challenges with grace and finding peace within myself."',
  );

  Future<void> saveToJournal() async {
    isSaving.value = true;

    try {
      // Simulate saving the weekly summary as a journal entry
      await Future.delayed(const Duration(seconds: 1));

      Get.snackbar(
        'Success',
        'Weekly summary saved to your journal!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save summary: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSaving.value = false;
    }
  }

  void shareSummary() {
    Get.snackbar(
      'Share',
      'Sharing functionality coming soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

class WeeklySummaryData {
  final String title;
  final String description;
  final String emotionalTheme;
  final String emotionalDescription;
  final List<KeyMoment> keyMoments;
  final String affirmation;

  WeeklySummaryData({
    required this.title,
    required this.description,
    required this.emotionalTheme,
    required this.emotionalDescription,
    required this.keyMoments,
    required this.affirmation,
  });
}

class KeyMoment {
  final String day;
  final String description;

  KeyMoment({
    required this.day,
    required this.description,
  });
}
