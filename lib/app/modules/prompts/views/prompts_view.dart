import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/prompts_controller.dart';

class PromptsView extends GetView<PromptsController> {
  const PromptsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        size: 24,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Text(
                    'Prompts',
                    style: AppTextStyles.h2.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  GestureDetector(
                    onTap: () => controller.getRandomPrompt(),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.textSecondary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Icon(
                        Icons.shuffle,
                        size: 24,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  )
                ],
              ),
            ),

            // Category Tabs
            Obx(() => Container(
                  padding: const EdgeInsets.all(12),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: controller.categories.map((category) {
                        final isSelected = controller.selectedCategory.value == category;
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: GestureDetector(
                            onTap: () => controller.selectCategory(category),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.textPrimary
                                    : AppColors.textSecondary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                category,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: isSelected ? AppColors.surface : AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                )),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.prompts.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.refreshPrompts,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Prompts List
                        Obx(() {
                          if (controller.isLoadingCategory.value) {
                            return const Padding(
                              padding: EdgeInsets.all(32),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          final filteredPrompts = controller.filteredPrompts;

                          if (filteredPrompts.isEmpty && !controller.isLoading.value) {
                            return Padding(
                              padding: const EdgeInsets.all(32),
                              child: Center(
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.lightbulb_outline,
                                      size: 64,
                                      color: AppColors.textMuted,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No prompts available',
                                      style: AppTextStyles.h4.copyWith(
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Pull down to refresh',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredPrompts.length,
                            itemBuilder: (context, index) {
                              final prompt = filteredPrompts[index];
                              return GestureDetector(
                                onTap: () => controller.selectPrompt(prompt),
                                child: Container(
                                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: AppColors.textSecondary.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Icon(
                                          Icons.lightbulb_outline,
                                          size: 24,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              constraints: const BoxConstraints(maxWidth: 294),
                                              child: Text(
                                                prompt.title,
                                                style: AppTextStyles.labelLarge.copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Container(
                                              constraints: const BoxConstraints(maxWidth: 294),
                                              child: Text(
                                                prompt.category.name,
                                                style: AppTextStyles.bodyMedium.copyWith(
                                                  color: AppColors.textSecondary,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                        const SizedBox(height: 80), // Space for bottom navigation
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
