import 'package:get/get.dart';

import '../../../data/models/user_profile.dart';

class ProfileController extends GetxController {
  final Rx<UserProfile> userProfile = UserProfile(
    id: '1',
    name: 'Sophia Carter',
    email: 'sophia@example.com',
    subtitle: 'Mindful Explorer',
    settings: UserSettings(
      notificationsEnabled: true,
      themeMode: ThemeMode.light,
      dataSharingEnabled: false,
    ),
    activityStats: ActivityStats(
      journalingStreakDays: 7,
      totalEntries: 35,
      averageMood: 'Positive',
      lastEntryDate: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ).obs;

  void toggleNotifications() {
    userProfile.value = userProfile.value.copyWith(
      settings: userProfile.value.settings.copyWith(
        notificationsEnabled: !userProfile.value.settings.notificationsEnabled,
      ),
    );
  }

  void toggleDataSharing() {
    userProfile.value = userProfile.value.copyWith(
      settings: userProfile.value.settings.copyWith(
        dataSharingEnabled: !userProfile.value.settings.dataSharingEnabled,
      ),
    );
  }

  void updateTheme(ThemeMode theme) {
    userProfile.value = userProfile.value.copyWith(
      settings: userProfile.value.settings.copyWith(themeMode: theme),
    );
  }

  void updateProfile({String? name, String? subtitle, String? avatarUrl}) {
    userProfile.value = userProfile.value.copyWith(
      name: name,
      subtitle: subtitle,
      avatarUrl: avatarUrl,
    );
  }

  String get currentThemeName {
    switch (userProfile.value.settings.themeMode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }
}
