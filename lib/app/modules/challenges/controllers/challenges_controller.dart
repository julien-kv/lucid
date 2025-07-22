import 'package:get/get.dart';

import '../../../data/models/challenge.dart';
import '../../../data/services/challenge_service.dart';

class ChallengesController extends GetxController {
  final ChallengeService _challengeService = Get.find<ChallengeService>();

  final RxList<Challenge> challenges = <Challenge>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadChallenges();
  }

  Future<void> loadChallenges() async {
    try {
      isLoading.value = true;
      error.value = '';

      // Load different types of challenges from API
      final featuredFuture = _challengeService.getFeaturedChallenges(limit: 3);
      final dailyPromptFuture = _challengeService.getDailyPromptChallenges(limit: 3);
      final themedFuture = _challengeService.getThemedChallenges(limit: 3);

      final results = await Future.wait([
        featuredFuture,
        dailyPromptFuture,
        themedFuture,
      ]);

      final featuredChallenges = _challengeService.convertToChallengeList(
        results[0],
        ChallengeType.featured,
      );

      final dailyPromptChallenges = _challengeService.convertToChallengeList(
        results[1],
        ChallengeType.dailyPrompt,
      );

      final themedChallenges = _challengeService.convertToChallengeList(
        results[2],
        ChallengeType.themed,
      );

      // Combine all challenges
      final allChallenges = [
        ...featuredChallenges,
        ...dailyPromptChallenges,
        ...themedChallenges,
      ];

      challenges.assignAll(allChallenges);
    } catch (e) {
      error.value = 'Failed to load challenges: ${e.toString()}';
      _loadFallbackChallenges();
    } finally {
      isLoading.value = false;
    }
  }

  void _loadFallbackChallenges() {
    // Fallback sample data in case API fails
    final sampleChallenges = [
      Challenge(
        id: '1',
        title: 'Mindful Moments',
        description: 'Find peace in daily meditation.',
        type: ChallengeType.featured,
        category: ChallengeCategory.mindfulness,
        progress: 75,
        completedDays: 22,
        totalDays: 30,
        imageUrl: 'https://example.com/mindful.jpg',
      ),
      Challenge(
        id: '2',
        title: 'Gratitude Journal',
        description: 'Reflect on your day\'s highlights.',
        type: ChallengeType.dailyPrompt,
        category: ChallengeCategory.gratitude,
        progress: 50,
        completedDays: 15,
        totalDays: 30,
      ),
      Challenge(
        id: '3',
        title: 'Self-Discovery Journey',
        description: 'Explore your inner self through writing.',
        type: ChallengeType.themed,
        category: ChallengeCategory.selfDiscovery,
        progress: 25,
        completedDays: 7,
        totalDays: 30,
      ),
    ];

    challenges.assignAll(sampleChallenges);
  }

  List<Challenge> get featuredChallenges {
    return challenges.where((challenge) => challenge.type == ChallengeType.featured).toList();
  }

  List<Challenge> get dailyPrompts {
    return challenges.where((challenge) => challenge.type == ChallengeType.dailyPrompt).toList();
  }

  List<Challenge> get themedChallenges {
    return challenges.where((challenge) => challenge.type == ChallengeType.themed).toList();
  }

  Future<void> startChallenge(String challengeId) async {
    try {
      final index = challenges.indexWhere((challenge) => challenge.id == challengeId);
      if (index != -1) {
        // Update local state immediately for better UX
        challenges[index] = challenges[index].copyWith(
          isActive: true,
          startDate: DateTime.now(),
        );

        // If the challengeId is numeric, call the API to update the challenge
        final numericId = int.tryParse(challengeId);
        if (numericId != null) {
          // In a real app, you might want to have a separate endpoint for starting challenges
          // For now, we'll just update the challenge status
          await _challengeService.updateChallenge(
            challengeId: numericId,
            isActive: true,
          );
        }
      }
    } catch (e) {
      error.value = 'Failed to start challenge: ${e.toString()}';
      // Revert the local change if API call fails
      final index = challenges.indexWhere((challenge) => challenge.id == challengeId);
      if (index != -1) {
        challenges[index] = challenges[index].copyWith(
          isActive: false,
          startDate: null,
        );
      }
    }
  }

  Future<void> updateChallengeProgress(String challengeId, int newProgress) async {
    try {
      final index = challenges.indexWhere((challenge) => challenge.id == challengeId);
      if (index != -1) {
        // Update local state immediately for better UX
        final oldChallenge = challenges[index];
        challenges[index] = oldChallenge.copyWith(
          progress: newProgress,
          completedDays: (newProgress * oldChallenge.totalDays / 100).round(),
        );

        // Note: In a real app, progress updates would typically be handled
        // by a separate user progress or challenge participation API
        // For now, we'll just update the local state
      }
    } catch (e) {
      error.value = 'Failed to update progress: ${e.toString()}';
    }
  }

  Future<void> refreshChallenges() async {
    await loadChallenges();
  }

  Future<void> searchChallenges(String query) async {
    if (query.isEmpty) {
      await loadChallenges();
      return;
    }

    try {
      isLoading.value = true;
      error.value = '';

      // Use the search API endpoint
      final searchResult = await _challengeService.searchChallengesByName(query);

      // Note: The API returns a string, so we might need to parse it
      // For now, we'll filter the existing challenges locally
      final filteredChallenges = challenges
          .where((challenge) =>
              challenge.title.toLowerCase().contains(query.toLowerCase()) ||
              challenge.description.toLowerCase().contains(query.toLowerCase()))
          .toList();

      challenges.assignAll(filteredChallenges);
    } catch (e) {
      error.value = 'Failed to search challenges: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }
}
