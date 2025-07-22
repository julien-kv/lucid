import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/challenge.dart';
import '../controllers/challenges_controller.dart';

class ChallengesView extends GetView<ChallengesController> {
  const ChallengesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        toolbarHeight: 80,
        title: Text(
          'Challenges',
          style: AppTextStyles.h4,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () => _showSearchDialog(context),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.search,
                  color: AppColors.textPrimary,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.challenges.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
        }

        if (controller.error.value.isNotEmpty && controller.challenges.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppColors.textMuted,
                ),
                const SizedBox(height: 16),
                Text(
                  'Failed to load challenges',
                  style: AppTextStyles.h4,
                ),
                const SizedBox(height: 8),
                Text(
                  controller.error.value,
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.refreshChallenges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshChallenges,
          color: AppColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Error banner (if error but has cached data)
                if (controller.error.value.isNotEmpty && controller.challenges.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.warning, color: Colors.red.shade600, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Using cached data. ${controller.error.value}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.red.shade700,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: controller.refreshChallenges,
                          child: Icon(Icons.refresh, color: Colors.red.shade600, size: 20),
                        ),
                      ],
                    ),
                  ),

                // Featured Section
                if (controller.featuredChallenges.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Featured',
                        style: AppTextStyles.h3,
                      ),
                      if (controller.isLoading.value)
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 320,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.featuredChallenges.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final challenge = controller.featuredChallenges[index];
                        return _buildFeaturedChallengeCard(challenge);
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                ],

                // Daily Prompts Section
                if (controller.dailyPrompts.isNotEmpty) ...[
                  Text(
                    'Daily Prompts',
                    style: AppTextStyles.h3,
                  ),
                  const SizedBox(height: 12),
                  Column(
                    children: controller.dailyPrompts
                        .map((challenge) => _buildDailyPromptCard(challenge))
                        .toList(),
                  ),
                  const SizedBox(height: 32),
                ],

                // Themed Challenges Section
                if (controller.themedChallenges.isNotEmpty) ...[
                  Text(
                    'Themed Challenges',
                    style: AppTextStyles.h3,
                  ),
                  const SizedBox(height: 12),
                  Column(
                    children: controller.themedChallenges
                        .map((challenge) => _buildThemedChallengeCard(challenge))
                        .toList(),
                  ),
                  const SizedBox(height: 32),
                ],

                // Empty state
                if (controller.challenges.isEmpty && !controller.isLoading.value) ...[
                  const SizedBox(height: 100),
                  Center(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.emoji_events_outlined,
                          size: 64,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No challenges available',
                          style: AppTextStyles.h4,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Check back later for new challenges',
                          style: AppTextStyles.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      }),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final searchController = TextEditingController();
        return AlertDialog(
          title: const Text('Search Challenges'),
          content: TextField(
            controller: searchController,
            decoration: const InputDecoration(
              hintText: 'Enter challenge name...',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final query = searchController.text.trim();
                Get.back();
                if (query.isNotEmpty) {
                  controller.searchChallenges(query);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFeaturedChallengeCard(Challenge challenge) {
    return GestureDetector(
      onTap: () => controller.startChallenge(challenge.id),
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: challenge.isActive ? Border.all(color: AppColors.primary, width: 2) : null,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image placeholder
              Container(
                height: 250,
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Image.network(
                        "https://images.unsplash.com/photo-1499750310107-5fef28a66643?q=80&w=1740&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (challenge.isActive)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Active',
                            style: AppTextStyles.labelSmall.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      challenge.title,
                      style: AppTextStyles.labelLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      challenge.description,
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDailyPromptCard(Challenge challenge) {
    return GestureDetector(
      onTap: () => controller.startChallenge(challenge.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: challenge.isActive ? Border.all(color: AppColors.primary, width: 2) : null,
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: challenge.isActive ? AppColors.primary : AppColors.lightGrey,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.edit,
                color: challenge.isActive ? Colors.white : AppColors.textPrimary,
                size: 24,
              ),
            ),

            const SizedBox(width: 16),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    challenge.title,
                    style: AppTextStyles.labelLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    challenge.description,
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            ),

            // Progress
            Column(
              children: [
                Container(
                  width: 88,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: challenge.progress / 100,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${challenge.progress}%',
                  style: AppTextStyles.labelMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemedChallengeCard(Challenge challenge) {
    return GestureDetector(
      onTap: () => controller.startChallenge(challenge.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: challenge.isActive ? Border.all(color: AppColors.primary, width: 2) : null,
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: challenge.isActive ? AppColors.primary : AppColors.lightGrey,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.psychology,
                color: challenge.isActive ? Colors.white : AppColors.textPrimary,
                size: 24,
              ),
            ),

            const SizedBox(width: 16),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    challenge.title,
                    style: AppTextStyles.labelLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    challenge.description,
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            ),

            // Progress
            Column(
              children: [
                Container(
                  width: 88,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: challenge.progress / 100,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${challenge.progress}%',
                  style: AppTextStyles.labelMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
