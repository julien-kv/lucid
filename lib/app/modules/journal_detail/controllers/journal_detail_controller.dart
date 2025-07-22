import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/journal_entry.dart';
import '../../../data/models/mood.dart';

class JournalDetailController extends GetxController {
  final Rx<JournalEntry?> journalEntry = Rx<JournalEntry?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Get the journal entry ID from arguments
    final entryId = Get.arguments as String?;
    if (entryId != null) {
      loadJournalEntry(entryId);
    }
  }

  void loadJournalEntry(String entryId) {
    isLoading.value = true;

    // Simulate loading the journal entry
    // In a real app, this would fetch from a database or API
    Future.delayed(const Duration(milliseconds: 500), () {
      // Sample data based on Figma design
      journalEntry.value = JournalEntry(
        id: entryId,
        title: 'Reflections on a Quiet Evening',
        content:
            '''Tonight, as the city lights dimmed and a gentle breeze rustled the leaves outside, I found myself enveloped in a profound sense of calm. The day's hustle and bustle faded into a distant memory, replaced by the quiet hum of my own thoughts. I spent the evening reading a book, its pages filled with stories of resilience and hope, and sipping a cup of chamomile tea, its warmth spreading through me like a comforting embrace. There's a certain magic in these quiet moments, a chance to reconnect with myself and appreciate the simple joys that often go unnoticed. I feel grateful for this evening, for the peace it brought, and for the reminder that sometimes, the greatest adventures are found in stillness.''',
        mood: Mood.happy,
        createdAt: DateTime(2024, 10, 26, 20, 15),
        updatedAt: DateTime(2024, 10, 26, 20, 15),
        attachments: ['assets/images/evening_photo.jpg'],
      );
      isLoading.value = false;
    });
  }

  void editEntry() {
    if (journalEntry.value != null) {
      Get.toNamed('/new-entry', arguments: journalEntry.value);
    }
  }

  void deleteEntry() {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Entry'),
        content: const Text(
            'Are you sure you want to delete this journal entry? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              Get.back(); // Go back to journals list
              Get.snackbar(
                'Success',
                'Journal entry deleted successfully',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void shareEntry() {
    if (journalEntry.value != null) {
      // In a real app, you'd use the share plugin
      Get.snackbar(
        'Share',
        'Sharing functionality coming soon!',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
