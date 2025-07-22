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
