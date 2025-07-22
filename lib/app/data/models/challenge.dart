enum ChallengeType {
  featured,
  dailyPrompt,
  themed,
}

enum ChallengeCategory {
  mindfulness,
  reflection,
  gratitude,
  mood,
  selfDiscovery,
  positivity,
}

// API Response Models
class ChallengeResponse {
  final int id;
  final String name;
  final String summary;
  final String? rules;
  final List<int> reward;
  final List<int> prompts;
  final List<RewardBadge>? rewardBadges;
  final List<ChallengePrompt>? challengePrompts;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChallengeResponse({
    required this.id,
    required this.name,
    required this.summary,
    this.rules,
    required this.reward,
    required this.prompts,
    this.rewardBadges,
    this.challengePrompts,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChallengeResponse.fromJson(Map<String, dynamic> json) {
    return ChallengeResponse(
      id: json['id'],
      name: json['name'],
      summary: json['summary'],
      rules: json['rules'],
      reward: List<int>.from(json['reward'] ?? []),
      prompts: List<int>.from(json['prompts'] ?? []),
      rewardBadges: json['reward_badges'] != null
          ? (json['reward_badges'] as List).map((badge) => RewardBadge.fromJson(badge)).toList()
          : null,
      challengePrompts: json['challenge_prompts'] != null
          ? (json['challenge_prompts'] as List)
              .map((prompt) => ChallengePrompt.fromJson(prompt))
              .toList()
          : null,
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'summary': summary,
      'rules': rules,
      'reward': reward,
      'prompts': prompts,
      'reward_badges': rewardBadges?.map((badge) => badge.toJson()).toList(),
      'challenge_prompts': challengePrompts?.map((prompt) => prompt.toJson()).toList(),
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class ChallengeListResponse {
  final int id;
  final String name;
  final String summary;
  final List<int> reward;
  final List<int> prompts;
  final bool isActive;

  ChallengeListResponse({
    required this.id,
    required this.name,
    required this.summary,
    required this.reward,
    required this.prompts,
    required this.isActive,
  });

  factory ChallengeListResponse.fromJson(Map<String, dynamic> json) {
    return ChallengeListResponse(
      id: json['id'],
      name: json['name'],
      summary: json['summary'],
      reward: List<int>.from(json['reward'] ?? []),
      prompts: List<int>.from(json['prompts'] ?? []),
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'summary': summary,
      'reward': reward,
      'prompts': prompts,
      'is_active': isActive,
    };
  }
}

class ChallengeCreate {
  final String name;
  final String summary;
  final String? rules;
  final List<int>? reward;
  final List<int>? prompts;

  ChallengeCreate({
    required this.name,
    required this.summary,
    this.rules,
    this.reward,
    this.prompts,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'summary': summary,
      if (rules != null) 'rules': rules,
      if (reward != null) 'reward': reward,
      if (prompts != null) 'prompts': prompts,
    };
  }
}

class ChallengeUpdate {
  final String? name;
  final String? summary;
  final String? rules;
  final List<int>? reward;
  final List<int>? prompts;
  final bool? isActive;

  ChallengeUpdate({
    this.name,
    this.summary,
    this.rules,
    this.reward,
    this.prompts,
    this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (summary != null) 'summary': summary,
      if (rules != null) 'rules': rules,
      if (reward != null) 'reward': reward,
      if (prompts != null) 'prompts': prompts,
      if (isActive != null) 'is_active': isActive,
    };
  }
}

class ChallengeBulkCreate {
  final List<ChallengeCreate> challenges;

  ChallengeBulkCreate({required this.challenges});

  Map<String, dynamic> toJson() {
    return {
      'challenges': challenges.map((challenge) => challenge.toJson()).toList(),
    };
  }
}

class ChallengeCreateResponse {
  final String message;
  final ChallengeResponse challenge;

  ChallengeCreateResponse({
    required this.message,
    required this.challenge,
  });

  factory ChallengeCreateResponse.fromJson(Map<String, dynamic> json) {
    return ChallengeCreateResponse(
      message: json['message'],
      challenge: ChallengeResponse.fromJson(json['challenge']),
    );
  }
}

class RewardBadge {
  final int id;
  final String name;
  final String info;
  final bool isActive;

  RewardBadge({
    required this.id,
    required this.name,
    required this.info,
    required this.isActive,
  });

  factory RewardBadge.fromJson(Map<String, dynamic> json) {
    return RewardBadge(
      id: json['id'],
      name: json['name'],
      info: json['info'],
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'info': info,
      'is_active': isActive,
    };
  }
}

class ChallengePrompt {
  final int id;
  final String prompt;
  final String category;
  final bool isActive;

  ChallengePrompt({
    required this.id,
    required this.prompt,
    required this.category,
    required this.isActive,
  });

  factory ChallengePrompt.fromJson(Map<String, dynamic> json) {
    return ChallengePrompt(
      id: json['id'],
      prompt: json['prompt'],
      category: json['category'],
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prompt': prompt,
      'category': category,
      'is_active': isActive,
    };
  }
}

// Legacy Challenge model for UI compatibility
class Challenge {
  final String id;
  final String title;
  final String description;
  final ChallengeType type;
  final ChallengeCategory category;
  final int progress; // percentage 0-100
  final int totalDays;
  final int completedDays;
  final String? imageUrl;
  final bool isActive;
  final DateTime? startDate;
  final DateTime? endDate;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.category,
    this.progress = 0,
    this.totalDays = 30,
    this.completedDays = 0,
    this.imageUrl,
    this.isActive = false,
    this.startDate,
    this.endDate,
  });

  Challenge copyWith({
    String? id,
    String? title,
    String? description,
    ChallengeType? type,
    ChallengeCategory? category,
    int? progress,
    int? totalDays,
    int? completedDays,
    String? imageUrl,
    bool? isActive,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return Challenge(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      category: category ?? this.category,
      progress: progress ?? this.progress,
      totalDays: totalDays ?? this.totalDays,
      completedDays: completedDays ?? this.completedDays,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  // Convert from API model to legacy model for UI compatibility
  factory Challenge.fromApiResponse(
    ChallengeResponse apiChallenge, {
    ChallengeType? type,
    ChallengeCategory? category,
    int progress = 0,
    int totalDays = 30,
    int completedDays = 0,
    String? imageUrl,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return Challenge(
      id: apiChallenge.id.toString(),
      title: apiChallenge.name,
      description: apiChallenge.summary,
      type: type ?? ChallengeType.featured,
      category: category ?? ChallengeCategory.mindfulness,
      progress: progress,
      totalDays: totalDays,
      completedDays: completedDays,
      imageUrl: imageUrl,
      isActive: apiChallenge.isActive,
      startDate: startDate,
      endDate: endDate,
    );
  }

  factory Challenge.fromApiListResponse(
    ChallengeListResponse apiChallenge, {
    ChallengeType? type,
    ChallengeCategory? category,
    int progress = 0,
    int totalDays = 30,
    int completedDays = 0,
    String? imageUrl,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return Challenge(
      id: apiChallenge.id.toString(),
      title: apiChallenge.name,
      description: apiChallenge.summary,
      type: type ?? ChallengeType.featured,
      category: category ?? ChallengeCategory.mindfulness,
      progress: progress,
      totalDays: totalDays,
      completedDays: completedDays,
      imageUrl: imageUrl,
      isActive: apiChallenge.isActive,
      startDate: startDate,
      endDate: endDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'category': category.name,
      'progress': progress,
      'totalDays': totalDays,
      'completedDays': completedDays,
      'imageUrl': imageUrl,
      'isActive': isActive,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: ChallengeType.values.firstWhere((e) => e.name == json['type']),
      category: ChallengeCategory.values.firstWhere((e) => e.name == json['category']),
      progress: json['progress'] ?? 0,
      totalDays: json['totalDays'] ?? 30,
      completedDays: json['completedDays'] ?? 0,
      imageUrl: json['imageUrl'],
      isActive: json['isActive'] ?? false,
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
    );
  }
}
