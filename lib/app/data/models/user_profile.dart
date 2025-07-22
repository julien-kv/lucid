class UserProfile {
  final String id;
  final String name;
  final String email;
  final String subtitle; // e.g., "Mindful Explorer"
  final String? avatarUrl;
  final UserSettings settings;
  final ActivityStats activityStats;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.subtitle = '',
    this.avatarUrl,
    required this.settings,
    required this.activityStats,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  // API compatibility factory
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'].toString(),
      name: json['full_name'] ?? json['username'] ?? '',
      email: json['email'] ?? '',
      subtitle: json['subtitle'] ?? '',
      avatarUrl: json['avatar_url'],
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
      settings: json['settings'] != null 
          ? UserSettings.fromJson(json['settings'])
          : UserSettings(),
      activityStats: json['activity_stats'] != null 
          ? ActivityStats.fromJson(json['activity_stats'])
          : ActivityStats(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': int.tryParse(id) ?? id,
        'username': name,
        'full_name': name,
        'email': email,
        'subtitle': subtitle,
        'avatar_url': avatarUrl,
        'is_active': isActive,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'settings': settings.toJson(),
        'activity_stats': activityStats.toJson(),
      };

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? subtitle,
    String? avatarUrl,
    UserSettings? settings,
    ActivityStats? activityStats,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      subtitle: subtitle ?? this.subtitle,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      settings: settings ?? this.settings,
      activityStats: activityStats ?? this.activityStats,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class UserSettings {
  final bool notificationsEnabled;
  final ThemeMode themeMode;
  final bool dataSharingEnabled;

  UserSettings({
    this.notificationsEnabled = true,
    this.themeMode = ThemeMode.light,
    this.dataSharingEnabled = false,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) => UserSettings(
        notificationsEnabled: json['notifications_enabled'] ?? true,
        themeMode: ThemeMode.values.firstWhere(
          (e) => e.name == json['theme_mode'],
          orElse: () => ThemeMode.light,
        ),
        dataSharingEnabled: json['data_sharing_enabled'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'notifications_enabled': notificationsEnabled,
        'theme_mode': themeMode.name,
        'data_sharing_enabled': dataSharingEnabled,
      };

  UserSettings copyWith({
    bool? notificationsEnabled,
    ThemeMode? themeMode,
    bool? dataSharingEnabled,
  }) {
    return UserSettings(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      themeMode: themeMode ?? this.themeMode,
      dataSharingEnabled: dataSharingEnabled ?? this.dataSharingEnabled,
    );
  }
}

enum ThemeMode {
  light,
  dark,
  system,
}

class ActivityStats {
  final int journalingStreakDays;
  final int totalEntries;
  final String averageMood; // e.g., "Positive"
  final DateTime? lastEntryDate;

  ActivityStats({
    this.journalingStreakDays = 0,
    this.totalEntries = 0,
    this.averageMood = 'Neutral',
    this.lastEntryDate,
  });

  factory ActivityStats.fromJson(Map<String, dynamic> json) => ActivityStats(
        journalingStreakDays: json['journaling_streak_days'] ?? 0,
        totalEntries: json['total_entries'] ?? 0,
        averageMood: json['average_mood'] ?? 'Neutral',
        lastEntryDate: json['last_entry_date'] != null
            ? DateTime.parse(json['last_entry_date'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'journaling_streak_days': journalingStreakDays,
        'total_entries': totalEntries,
        'average_mood': averageMood,
        'last_entry_date': lastEntryDate?.toIso8601String(),
      };

  ActivityStats copyWith({
    int? journalingStreakDays,
    int? totalEntries,
    String? averageMood,
    DateTime? lastEntryDate,
  }) {
    return ActivityStats(
      journalingStreakDays: journalingStreakDays ?? this.journalingStreakDays,
      totalEntries: totalEntries ?? this.totalEntries,
      averageMood: averageMood ?? this.averageMood,
      lastEntryDate: lastEntryDate ?? this.lastEntryDate,
    );
  }
}
