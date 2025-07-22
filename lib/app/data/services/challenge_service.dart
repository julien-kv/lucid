import 'package:get/get.dart';

import '../../core/api/api_client.dart';
import '../../core/api/api_config.dart';
import '../models/challenge.dart';

class ChallengeService extends GetxService {
  final ApiClient _apiClient = ApiClient.instance;

  /// Create a new challenge
  Future<ChallengeCreateResponse> createChallenge({
    required String name,
    required String summary,
    String? rules,
    List<int>? reward,
    List<int>? prompts,
  }) async {
    final challengeData = ChallengeCreate(
      name: name,
      summary: summary,
      rules: rules,
      reward: reward,
      prompts: prompts,
    );

    final response = await _apiClient.post(
      ApiConfig.challenges,
      data: challengeData.toJson(),
    );

    return ChallengeCreateResponse.fromJson(response.data);
  }

  /// Create multiple challenges in bulk
  Future<ChallengeCreateResponse> createChallengesBulk({
    required List<ChallengeCreate> challenges,
  }) async {
    final bulkData = ChallengeBulkCreate(challenges: challenges);

    final response = await _apiClient.post(
      ApiConfig.challenges,
      data: bulkData.toJson(),
    );

    return ChallengeCreateResponse.fromJson(response.data);
  }

  /// Get list of challenges with optional filtering
  Future<List<ChallengeListResponse>> getChallenges({
    int skip = 0,
    int limit = 50,
    String? nameFilter,
    bool activeOnly = true,
  }) async {
    final queryParams = <String, dynamic>{
      'skip': skip,
      'limit': limit,
      'active_only': activeOnly,
    };

    if (nameFilter != null && nameFilter.isNotEmpty) {
      queryParams['name_filter'] = nameFilter;
    }

    final response = await _apiClient.get(
      ApiConfig.challenges,
      queryParameters: queryParams,
    );

    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((item) => ChallengeListResponse.fromJson(item)).toList();
  }

  /// Get a specific challenge by ID with optional resolved relationships
  Future<ChallengeResponse> getChallengeById(
    int challengeId, {
    bool includeDetails = true,
  }) async {
    final response = await _apiClient.get(
      ApiConfig.challengeById(challengeId),
      queryParameters: {
        'include_details': includeDetails,
      },
    );

    return ChallengeResponse.fromJson(response.data);
  }

  /// Update a challenge
  Future<ChallengeResponse> updateChallenge({
    required int challengeId,
    String? name,
    String? summary,
    String? rules,
    List<int>? reward,
    List<int>? prompts,
    bool? isActive,
  }) async {
    final updateData = ChallengeUpdate(
      name: name,
      summary: summary,
      rules: rules,
      reward: reward,
      prompts: prompts,
      isActive: isActive,
    );

    final response = await _apiClient.put(
      ApiConfig.challengeById(challengeId),
      data: updateData.toJson(),
    );

    return ChallengeResponse.fromJson(response.data);
  }

  /// Delete a challenge
  Future<String> deleteChallenge(int challengeId) async {
    final response = await _apiClient.delete(ApiConfig.challengeById(challengeId));
    return response.data as String;
  }

  /// Search challenges by name (partial match)
  Future<String> searchChallengesByName(
    String name, {
    int skip = 0,
    int limit = 20,
  }) async {
    final response = await _apiClient.get(
      ApiConfig.searchChallengesByName(name),
      queryParameters: {
        'skip': skip,
        'limit': limit,
      },
    );

    return response.data as String;
  }

  /// Get challenge statistics
  Future<String> getChallengeStatistics() async {
    final response = await _apiClient.get(ApiConfig.challengeStats);
    return response.data as String;
  }

  /// Get featured challenges (helper method)
  Future<List<ChallengeListResponse>> getFeaturedChallenges({
    int limit = 10,
  }) async {
    // In a real implementation, you might filter by a specific criterion
    // For now, we'll get the first few active challenges
    return getChallenges(skip: 0, limit: limit, activeOnly: true);
  }

  /// Get daily prompt challenges (helper method)
  Future<List<ChallengeListResponse>> getDailyPromptChallenges({
    int limit = 10,
  }) async {
    // Filter by challenges that have prompts
    final challenges = await getChallenges(skip: 0, limit: limit * 2, activeOnly: true);
    return challenges.where((challenge) => challenge.prompts.isNotEmpty).take(limit).toList();
  }

  /// Get themed challenges (helper method)
  Future<List<ChallengeListResponse>> getThemedChallenges({
    int limit = 10,
  }) async {
    // For themed challenges, we might want challenges with specific criteria
    // For now, get challenges that have both rewards and prompts
    final challenges = await getChallenges(skip: 0, limit: limit * 2, activeOnly: true);
    return challenges
        .where((challenge) => challenge.reward.isNotEmpty && challenge.prompts.isNotEmpty)
        .take(limit)
        .toList();
  }

  /// Convert API list responses to legacy Challenge models for UI compatibility
  List<Challenge> convertToChallengeList(
    List<ChallengeListResponse> apiChallenges,
    ChallengeType type,
  ) {
    return apiChallenges.map((apiChallenge) {
      // Determine category based on challenge content or other criteria
      final category = _determineCategoryFromChallenge(apiChallenge);

      // Generate some mock progress data for UI
      final progress = _generateMockProgress();
      final totalDays = 30;
      final completedDays = (progress * totalDays / 100).round();

      return Challenge.fromApiListResponse(
        apiChallenge,
        type: type,
        category: category,
        progress: progress,
        totalDays: totalDays,
        completedDays: completedDays,
      );
    }).toList();
  }

  /// Helper method to determine category from challenge data
  ChallengeCategory _determineCategoryFromChallenge(ChallengeListResponse challenge) {
    final name = challenge.name.toLowerCase();
    final summary = challenge.summary.toLowerCase();

    if (name.contains('mindful') ||
        summary.contains('mindful') ||
        name.contains('meditation') ||
        summary.contains('meditation')) {
      return ChallengeCategory.mindfulness;
    } else if (name.contains('gratitude') || summary.contains('gratitude')) {
      return ChallengeCategory.gratitude;
    } else if (name.contains('mood') || summary.contains('mood')) {
      return ChallengeCategory.mood;
    } else if (name.contains('reflect') ||
        summary.contains('reflect') ||
        name.contains('writing') ||
        summary.contains('writing')) {
      return ChallengeCategory.reflection;
    } else if (name.contains('positive') || summary.contains('positive')) {
      return ChallengeCategory.positivity;
    } else {
      return ChallengeCategory.selfDiscovery;
    }
  }

  /// Helper method to generate mock progress data
  int _generateMockProgress() {
    // Generate random progress between 10-90%
    return 10 + (DateTime.now().millisecondsSinceEpoch % 80);
  }
}
