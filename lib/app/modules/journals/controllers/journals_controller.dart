import 'package:get/get.dart';

import '../../../data/models/journal_entry.dart';
import '../../../data/models/mood.dart';

class JournalsController extends GetxController {
  final RxList<JournalEntry> journalEntries = <JournalEntry>[].obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with sample data based on Figma designs
    _loadSampleJournalEntries();
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
      JournalEntry(
        id: '4',
        title: 'Setting intentions for the week',
        content: 'This week I want to focus on mindfulness, connection, and personal growth...',
        mood: Mood.neutral,
        createdAt: now.subtract(const Duration(days: 7)),
        updatedAt: now.subtract(const Duration(days: 7)),
      ),
      JournalEntry(
        id: '5',
        title: 'Dealing with setbacks',
        content:
            'Sometimes life throws curveballs, but each challenge is an opportunity to grow stronger...',
        mood: Mood.sad,
        createdAt: now.subtract(const Duration(days: 7, hours: 2)),
        updatedAt: now.subtract(const Duration(days: 7, hours: 2)),
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
  }

  void addJournalEntry(JournalEntry entry) {
    journalEntries.insert(0, entry);
  }

  void updateJournalEntry(JournalEntry updatedEntry) {
    final index = journalEntries.indexWhere((entry) => entry.id == updatedEntry.id);
    if (index != -1) {
      journalEntries[index] = updatedEntry;
    }
  }

  void deleteJournalEntry(String entryId) {
    journalEntries.removeWhere((entry) => entry.id == entryId);
  }
}
