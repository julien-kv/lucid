import 'package:get/get.dart';

import '../../core/api/api_client.dart';
import '../../core/api/api_config.dart';
import '../models/api/journal_models.dart';

class JournalService extends GetxService {
  final ApiClient _apiClient = ApiClient.instance;

  /// Create a new journal entry
  Future<JournalCreateResponse> createJournal({
    required String title,
    required String content,
    required String mood,
    List<String>? images,
    String? audio,
    String? summary,
  }) async {
    final journalData = JournalCreate(
      title: title,
      content: content,
      mood: mood,
      images: images,
      audio: audio,
      summary: summary,
    );

    final response = await _apiClient.post(
      ApiConfig.journals,
      data: journalData.toJson(),
    );

    return JournalCreateResponse.fromJson(response.data);
  }

  /// Get list of journal entries
  Future<List<JournalListResponse>> getJournals({
    int skip = 0,
    int limit = 10,
    String? mood,
  }) async {
    final queryParams = <String, dynamic>{
      'skip': skip,
      'limit': limit,
    };

    if (mood != null && mood.isNotEmpty) {
      queryParams['mood'] = mood;
    }

    final response = await _apiClient.get(
      ApiConfig.journals,
      queryParameters: queryParams,
    );

    final List<dynamic> journalsData = response.data;
    return journalsData.map((json) => JournalListResponse.fromJson(json)).toList();
  }

  /// Get a specific journal entry by ID
  Future<JournalResponse> getJournalById(int journalId) async {
    final response = await _apiClient.get(
      ApiConfig.journalById(journalId),
    );

    return JournalResponse.fromJson(response.data);
  }

  /// Update a journal entry
  Future<JournalResponse> updateJournal({
    required int journalId,
    String? title,
    String? content,
    String? mood,
    List<String>? images,
    String? audio,
    String? summary,
  }) async {
    final updateData = JournalUpdate(
      title: title,
      content: content,
      mood: mood,
      images: images,
      audio: audio,
      summary: summary,
    );

    final response = await _apiClient.put(
      ApiConfig.journalById(journalId),
      data: updateData.toJson(),
    );

    return JournalResponse.fromJson(response.data);
  }

  /// Delete a journal entry
  Future<void> deleteJournal(int journalId) async {
    await _apiClient.delete(ApiConfig.journalById(journalId));
  }

  /// Get journal entries by specific mood
  Future<List<JournalListResponse>> getJournalsByMood({
    required String mood,
    int skip = 0,
    int limit = 10,
  }) async {
    final queryParams = <String, dynamic>{
      'skip': skip,
      'limit': limit,
    };

    final response = await _apiClient.get(
      ApiConfig.journalsByMood(mood),
      queryParameters: queryParams,
    );

    final List<dynamic> journalsData = response.data;
    return journalsData.map((json) => JournalListResponse.fromJson(json)).toList();
  }

  /// Get mood statistics
  Future<MoodStatistics> getMoodStatistics() async {
    final response = await _apiClient.get(ApiConfig.moodStats);
    return MoodStatistics.fromJson(response.data);
  }

  /// Get available moods
  Future<List<String>> getAvailableMoods() async {
    final response = await _apiClient.get(ApiConfig.moods);

    // Assuming the API returns a list of mood strings
    if (response.data is List) {
      return List<String>.from(response.data);
    } else if (response.data is Map) {
      // If it returns a map, extract the values or keys as needed
      return List<String>.from(response.data.values);
    }

    // Fallback to default moods
    return ['happy', 'sad', 'angry', 'anxious', 'neutral'];
  }

  /// Get recent journal entries (helper method)
  Future<List<JournalListResponse>> getRecentJournals({int limit = 5}) async {
    return getJournals(skip: 0, limit: limit);
  }

  /// Search journal entries by content (if API supports it)
  Future<List<JournalListResponse>> searchJournals({
    required String query,
    int skip = 0,
    int limit = 10,
  }) async {
    // This would need to be implemented if the API supports search
    // For now, we'll use the regular getJournals and filter client-side
    final allJournals = await getJournals(skip: skip, limit: limit * 2);

    return allJournals
        .where((journal) =>
            journal.title.toLowerCase().contains(query.toLowerCase()) ||
            journal.content.toLowerCase().contains(query.toLowerCase()))
        .take(limit)
        .toList();
  }
}
