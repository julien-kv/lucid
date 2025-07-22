import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/exceptions/api_exceptions.dart';
import '../../../data/models/journal_entry.dart';
import '../../../data/models/mood.dart';
import '../../../data/services/journal_service.dart';
import '../../journals/controllers/journals_controller.dart';

class JournalDetailController extends GetxController {
  final Rx<JournalEntry?> journalEntry = Rx<JournalEntry?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isDeleting = false.obs;

  final JournalService _journalService = Get.find<JournalService>();

  @override
  void onInit() {
    super.onInit();
    // Get the journal entry ID from arguments
    final entryId = Get.arguments as String?;
    if (entryId != null) {
      loadJournalEntry(entryId);
    }
  }

  Future<void> loadJournalEntry(String entryId) async {
    try {
      isLoading.value = true;

      final journalId = int.parse(entryId);
      final apiJournal = await _journalService.getJournalById(journalId);

      // Convert API journal to local journal entry model
      journalEntry.value = JournalEntry(
        id: apiJournal.id.toString(),
        title: apiJournal.title,
        content: apiJournal.content,
        mood: _mapStringToMood(apiJournal.mood),
        createdAt: apiJournal.createdAt,
        updatedAt: apiJournal.updatedAt,
        attachments: apiJournal.images ?? [],
      );
      
    } on NetworkException {
      Get.snackbar(
        'Network Error',
        'Please check your internet connection',
        snackPosition: SnackPosition.TOP,
      );
      _loadFallbackEntry(entryId);
    } on NotFoundException {
      Get.snackbar(
        'Not Found',
        'Journal entry not found',
        snackPosition: SnackPosition.TOP,
      );
      Get.back();
    } on ApiException catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load journal: ${e.message}',
        snackPosition: SnackPosition.TOP,
      );
      _loadFallbackEntry(entryId);
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        snackPosition: SnackPosition.TOP,
      );
      _loadFallbackEntry(entryId);
    } finally {
      isLoading.value = false;
    }
  }

  Mood _mapStringToMood(String moodString) {
    switch (moodString.toLowerCase()) {
      case 'happy':
        return Mood.happy;
      case 'sad':
        return Mood.sad;
      case 'angry':
        return Mood.angry;
      case 'anxious':
        return Mood.anxious;
      case 'neutral':
      default:
        return Mood.neutral;
    }
  }

  void _loadFallbackEntry(String entryId) {
    // Fallback sample data
    journalEntry.value = JournalEntry(
      id: entryId,
      title: 'Reflections on a Quiet Evening',
      content:
          '''Tonight, as the city lights dimmed and a gentle breeze rustled the leaves outside, I found myself enveloped in a profound sense of calm. The day's hustle and bustle faded into a distant memory, replaced by the quiet hum of my own thoughts. I spent the evening reading a book, its pages filled with stories of resilience and hope, and sipping a cup of chamomile tea, its warmth spreading through me like a comforting embrace. There's a certain magic in these quiet moments, a chance to reconnect with myself and appreciate the simple joys that often go unnoticed. I feel grateful for this evening, for the peace it brought, and for the reminder that sometimes, the greatest adventures are found in stillness.''',
      mood: Mood.happy,
      createdAt: DateTime(2024, 10, 26, 20, 15),
      updatedAt: DateTime(2024, 10, 26, 20, 15),
      attachments: [],
    );
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
            onPressed: () async {
              Get.back(); // Close dialog
              await _performDelete();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _performDelete() async {
    if (journalEntry.value == null) return;

    try {
      isDeleting.value = true;

      final journalId = int.parse(journalEntry.value!.id);
      await _journalService.deleteJournal(journalId);

      // Refresh journals list if controller exists
      try {
        final journalsController = Get.find<JournalsController>();
        journalsController.refreshJournals();
      } catch (e) {
        // Journals controller not found, that's okay
      }

      Get.snackbar(
        'Success',
        'Journal entry deleted successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withValues(alpha: 0.1),
        colorText: Colors.green,
      );

      Get.back(); // Go back to journals list
    } on NetworkException {
      Get.snackbar(
        'Network Error',
        'Please check your internet connection',
        snackPosition: SnackPosition.TOP,
      );
    } on ApiException catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete journal: ${e.message}',
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isDeleting.value = false;
    }
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
