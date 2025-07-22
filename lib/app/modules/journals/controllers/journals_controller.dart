import 'dart:async';

import 'package:get/get.dart';

import '../../../core/exceptions/api_exceptions.dart';
import '../../../data/models/journal_entry.dart';
import '../../../data/models/mood.dart';
import '../../../data/services/journal_service.dart';

class JournalsController extends GetxController {
  final RxList<JournalEntry> journalEntries = <JournalEntry>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isSearching = false.obs;

  final JournalService _journalService = Get.find<JournalService>();

  @override
  void onInit() {
    super.onInit();
    loadJournals();
  }

  Future<void> loadJournals({int limit = 50}) async {
    try {
      isLoading.value = true;

      final apiJournals = await _journalService.getJournals(limit: limit);

      // Convert API journal models to local journal entry models
      final entries = apiJournals
          .map((apiJournal) => JournalEntry(
                id: apiJournal.id.toString(),
                title: apiJournal.title,
                content: apiJournal.content,
                mood: _mapStringToMood(apiJournal.mood),
                createdAt: apiJournal.createdAt,
                updatedAt: apiJournal.updatedAt,
                tags: [], // Add if needed
                attachments: [], // Add if needed
              ))
          .toList();

      journalEntries.assignAll(entries);
    } on NetworkException {
      Get.snackbar(
        'Network Error',
        'Please check your internet connection',
        snackPosition: SnackPosition.TOP,
      );
      // Fallback to sample data for demo
      _loadSampleJournalEntries();
    } on ApiException catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load journals: ${e.message}',
        snackPosition: SnackPosition.TOP,
      );
      _loadSampleJournalEntries();
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        snackPosition: SnackPosition.TOP,
      );
      _loadSampleJournalEntries();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> searchJournals(String query) async {
    if (query.isEmpty) {
      loadJournals();
      return;
    }

    try {
      isSearching.value = true;

      final apiJournals = await _journalService.searchJournals(query: query);

      final entries = apiJournals
          .map((apiJournal) => JournalEntry(
                id: apiJournal.id.toString(),
                title: apiJournal.title,
                content: apiJournal.content,
                mood: _mapStringToMood(apiJournal.mood),
                createdAt: apiJournal.createdAt,
                updatedAt: apiJournal.updatedAt,
                tags: [],
                attachments: [],
              ))
          .toList();

      journalEntries.assignAll(entries);
    } on NetworkException {
      Get.snackbar(
        'Network Error',
        'Please check your internet connection',
        snackPosition: SnackPosition.TOP,
      );
    } on ApiException catch (e) {
      Get.snackbar(
        'Search Error',
        'Failed to search journals: ${e.message}',
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred during search',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isSearching.value = false;
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

  void _loadSampleJournalEntries() {
    final now = DateTime.now();
    final sampleEntries = [
      JournalEntry(
        id: '1',
        title: 'Reflecting on the day\'s events',
        content: 'Today was filled with meaningful moments and quiet reflections...',
        mood: Mood.happy,
        createdAt: now.subtract(const Duration(hours: 6)),
        updatedAt: now.subtract(const Duration(hours: 6)),
      ),
      JournalEntry(
        id: '2',
        title: 'Gratitude for small joys',
        content:
            'Found beauty in the simple things today. The morning coffee, a kind smile from a stranger...',
        mood: Mood.happy,
        createdAt: now.subtract(const Duration(days: 1, hours: 3)),
        updatedAt: now.subtract(const Duration(days: 1, hours: 3)),
      ),
      JournalEntry(
        id: '3',
        title: 'Managing stress and anxiety',
        content: 'Learning to breathe through difficult moments and find peace within the chaos...',
        mood: Mood.anxious,
        createdAt: now.subtract(const Duration(days: 1, hours: 13)),
        updatedAt: now.subtract(const Duration(days: 1, hours: 13)),
      ),
    ];

    journalEntries.assignAll(sampleEntries);
  }

  List<JournalEntry> get filteredEntries {
    if (searchQuery.value.isEmpty) {
      return journalEntries;
    }

    return journalEntries.where((entry) {
      return entry.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          entry.content.toLowerCase().contains(searchQuery.value.toLowerCase());
    }).toList();
  }

  Map<String, List<JournalEntry>> get groupedEntries {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final weekAgo = today.subtract(const Duration(days: 7));

    final Map<String, List<JournalEntry>> grouped = {
      'Today': [],
      'Yesterday': [],
      'Last Week': [],
    };

    for (final entry in filteredEntries) {
      final entryDate = DateTime(entry.createdAt.year, entry.createdAt.month, entry.createdAt.day);

      if (entryDate.isAtSameMomentAs(today)) {
        grouped['Today']!.add(entry);
      } else if (entryDate.isAtSameMomentAs(yesterday)) {
        grouped['Yesterday']!.add(entry);
      } else if (entryDate.isAfter(weekAgo)) {
        grouped['Last Week']!.add(entry);
      }
    }

    return grouped;
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;

    // Debounce search to avoid too many API calls
    _debounceSearchTimer?.cancel();
    _debounceSearchTimer = Timer(const Duration(milliseconds: 500), () {
      searchJournals(query);
    });
  }

  Timer? _debounceSearchTimer;

  void addJournalEntry(JournalEntry entry) {
    journalEntries.insert(0, entry);
  }

  void updateJournalEntry(JournalEntry updatedEntry) {
    final index = journalEntries.indexWhere((entry) => entry.id == updatedEntry.id);
    if (index != -1) {
      journalEntries[index] = updatedEntry;
    }
  }

  Future<void> deleteJournalEntry(String entryId) async {
    try {
      await _journalService.deleteJournal(int.parse(entryId));
      journalEntries.removeWhere((entry) => entry.id == entryId);

      Get.snackbar(
        'Success',
        'Journal entry deleted',
        snackPosition: SnackPosition.TOP,
      );
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
    }
  }

  Future<void> refreshJournals() async {
    await loadJournals();
  }

  @override
  void onClose() {
    _debounceSearchTimer?.cancel();
    super.onClose();
  }
}
