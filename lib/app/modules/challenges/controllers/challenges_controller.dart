import 'package:get/get.dart';

import '../../../data/models/challenge.dart';

class ChallengesController extends GetxController {
  final RxList<Challenge> challenges = <Challenge>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadSampleChallenges();
  }

  void _loadSampleChallenges() {
    final sampleChallenges = [
      // Featured Challenges
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
        title: 'Reflective Writing',
        description: 'Explore your thoughts through journaling.',
        type: ChallengeType.featured,
        category: ChallengeCategory.reflection,
        progress: 50,
        completedDays: 15,
        totalDays: 30,
        imageUrl: 'https://example.com/writing.jpg',
      ),
      Challenge(
        id: '3',
        title: 'Nature\'s Embrace',
        description: 'Connect with nature for inner calm.',
        type: ChallengeType.featured,
        category: ChallengeCategory.mindfulness,
        progress: 25,
        completedDays: 7,
        totalDays: 30,
        imageUrl: 'https://example.com/nature.jpg',
      ),

      // Daily Prompts
      Challenge(
        id: '4',
        title: 'Gratitude Journal',
        description: 'Reflect on your day\'s highlights.',
        type: ChallengeType.dailyPrompt,
        category: ChallengeCategory.gratitude,
        progress: 75,
        completedDays: 22,
        totalDays: 30,
      ),
      Challenge(
        id: '5',
        title: 'Mood Tracker',
        description: 'Express your emotions through writing.',
        type: ChallengeType.dailyPrompt,
        category: ChallengeCategory.mood,
        progress: 50,
        completedDays: 15,
        totalDays: 30,
      ),

      // Themed Challenges
      Challenge(
        id: '6',
        title: 'Self-Discovery Journey',
        description: 'Explore your inner self through writing.',
        type: ChallengeType.themed,
        category: ChallengeCategory.selfDiscovery,
        progress: 25,
        completedDays: 7,
        totalDays: 30,
      ),
      Challenge(
        id: '7',
        title: 'Positivity Project',
        description: 'Cultivate positive thinking habits.',
        type: ChallengeType.themed,
        category: ChallengeCategory.positivity,
        progress: 60,
        completedDays: 18,
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

  void startChallenge(String challengeId) {
    final index = challenges.indexWhere((challenge) => challenge.id == challengeId);
    if (index != -1) {
      challenges[index] = challenges[index].copyWith(
        isActive: true,
        startDate: DateTime.now(),
      );
    }
  }

  void updateChallengeProgress(String challengeId, int newProgress) {
    final index = challenges.indexWhere((challenge) => challenge.id == challengeId);
    if (index != -1) {
      challenges[index] = challenges[index].copyWith(
        progress: newProgress,
        completedDays: (newProgress * challenges[index].totalDays / 100).round(),
      );
    }
  }
}
