import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        toolbarHeight: 80,
        title: Text(
          'Profile',
          style: AppTextStyles.h4,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.more_vert,
                color: AppColors.textPrimary,
                size: 24,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Obx(() {
          final profile = controller.userProfile.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Profile Section
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Avatar
                    Container(
                      width: 128,
                      height: 128,
                      decoration: BoxDecoration(
                        color: AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(64),
                      ),
                      child: profile.avatarUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(64),
                              child: Image.network(
                                profile.avatarUrl!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(
                              Icons.person,
                              size: 64,
                              color: AppColors.textMuted,
                            ),
                    ),

                    const SizedBox(height: 16),

                    // Name
                    Text(
                      profile.name,
                      style: AppTextStyles.h3,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 4),

                    // Subtitle
                    Text(
                      profile.subtitle,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textMuted,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Account Section
              Text(
                'Account',
                style: AppTextStyles.h4,
              ),
              const SizedBox(height: 8),

              _buildSettingItem(
                title: 'Notifications',
                trailing: Switch(
                  value: profile.settings.notificationsEnabled,
                  onChanged: (_) => controller.toggleNotifications(),
                  activeColor: AppColors.surface,
                  activeTrackColor: AppColors.primary,
                  inactiveTrackColor: AppColors.lightGrey,
                ),
              ),

              _buildSettingItem(
                title: 'Theme',
                trailing: Text(
                  controller.currentThemeName,
                  style: AppTextStyles.bodyLarge,
                ),
              ),

              const SizedBox(height: 24),

              // Privacy Section
              Text(
                'Privacy',
                style: AppTextStyles.h4,
              ),
              const SizedBox(height: 8),

              _buildSettingItem(
                title: 'Data Sharing',
                trailing: Switch(
                  value: profile.settings.dataSharingEnabled,
                  onChanged: (_) => controller.toggleDataSharing(),
                  activeColor: AppColors.surface,
                  activeTrackColor: AppColors.primary,
                  inactiveTrackColor: AppColors.lightGrey,
                ),
              ),

              _buildSettingItem(
                title: 'Terms of Service',
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.textPrimary,
                  size: 16,
                ),
              ),

              const SizedBox(height: 24),

              // Activity Section
              Text(
                'Activity',
                style: AppTextStyles.h4,
              ),
              const SizedBox(height: 8),

              _buildSettingItem(
                title: 'Journaling Streak',
                trailing: Text(
                  '${profile.activityStats.journalingStreakDays} days',
                  style: AppTextStyles.bodyLarge,
                ),
              ),

              _buildSettingItem(
                title: 'Total Entries',
                trailing: Text(
                  '${profile.activityStats.totalEntries}',
                  style: AppTextStyles.bodyLarge,
                ),
              ),

              _buildSettingItem(
                title: 'Average Mood',
                trailing: Text(
                  profile.activityStats.averageMood,
                  style: AppTextStyles.bodyLarge,
                ),
              ),

              const SizedBox(height: 32),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildSettingItem({
    required String title,
    required Widget trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 0),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        color: AppColors.background,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.bodyLarge,
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
