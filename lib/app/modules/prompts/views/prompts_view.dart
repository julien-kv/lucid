import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/journal_prompt.dart';
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
                  const SizedBox(width: 48), // Placeholder for symmetry
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Filter Tabs
                    Container(
                      padding: const EdgeInsets.all(12),
                      child: Obx(() => SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: PromptCategory.values.map((category) {
                                final isSelected = controller.selectedCategory.value == category;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: GestureDetector(
                                    onTap: () => controller.selectCategory(category),
                                    child: Container(
                                      padding:
                                          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppColors.textPrimary
                                            : AppColors.textSecondary.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        category.displayName,
                                        style: AppTextStyles.bodyMedium.copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: isSelected
                                              ? AppColors.surface
                                              : AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          )),
                    ),

                    // Featured Section
                    Obx(() {
                      final featuredPrompt = controller.featuredPrompt;
                      if (featuredPrompt == null) return const SizedBox.shrink();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: Text(
                              'Featured',
                              style: AppTextStyles.h2.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(16),
                            child: GestureDetector(
                              onTap: () => controller.selectPrompt(featuredPrompt),
                              child: Container(
                                height: 224,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.amber.withValues(alpha: 0.3),
                                      Colors.orange.withValues(alpha: 0.7),
                                    ],
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 16,
                                      right: 16,
                                      bottom: 16,
                                      child: Text(
                                        featuredPrompt.title,
                                        style: AppTextStyles.h1.copyWith(
                                          color: AppColors.surface,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 24,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),

                    // All Prompts Section
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Text(
                        'All Prompts',
                        style: AppTextStyles.h2.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ),

                    // Prompts List
                    Obx(() {
                      final filteredPrompts = controller.filteredPrompts;
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
                                          constraints: BoxConstraints(
                                            maxWidth: prompt.category ==
                                                    PromptCategory.emotionalProcessing
                                                ? 206
                                                : 294,
                                          ),
                                          child: Text(
                                            prompt.category.displayName,
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
            ),
          ],
        ),
      ),
    );
  }
}
