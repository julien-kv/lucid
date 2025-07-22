class UserProfile {
  final String id;
  final String name;
  final String email;
  final String subtitle; // e.g., "Mindful Explorer"
  final String? avatarUrl;
  final UserSettings settings;
  final ActivityStats activityStats;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.subtitle = '',
    this.avatarUrl,
    required this.settings,
    required this.activityStats,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? subtitle,
    String? avatarUrl,
    UserSettings? settings,
    ActivityStats? activityStats,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      subtitle: subtitle ?? this.subtitle,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      settings: settings ?? this.settings,
      activityStats: activityStats ?? this.activityStats,
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
