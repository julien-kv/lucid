import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/microjournal_controller.dart';

class MicrojournalView extends GetView<MicrojournalController> {
  const MicrojournalView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        toolbarHeight: 80,
        title: Text(
          'Microjournal',
          style: AppTextStyles.h4,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  // Question
                  Text(
                    'How are you feeling right now?',
                    style: AppTextStyles.h2,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  // Mood Selection
                  Wrap(
                    spacing: 12,
                    children:
                        controller.moodEmojis.map((emoji) => _buildMoodButton(emoji)).toList(),
                  ),

                  const SizedBox(height: 32),

                  // Text Input
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: TextField(
                      controller: controller.thoughtsController,
                      style: AppTextStyles.bodyLarge,
                      decoration: InputDecoration(
                        hintText: 'Add 2-3 words',
                        hintStyle: AppTextStyles.inputPlaceholder,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(15),
                      ),
                      maxLength: 50,
                      buildCounter: (context,
                          {required currentLength, required isFocused, maxLength}) {
                        return null; // Hide the counter
                      },
                    ),
                  ),

                  const Spacer(),
                ],
              ),
            ),
          ),

          // Save Button
          Container(
            padding: const EdgeInsets.all(16),
            child: Obx(() => SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: controller.isSaving.value ? null : controller.saveEntry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryLight,
                      foregroundColor: AppColors.textPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: controller.isSaving.value
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.textPrimary,
                              ),
                            ),
                          )
                        : Text(
                            'Save',
                            style: AppTextStyles.buttonMedium.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodButton(String emoji) {
    return Obx(() => GestureDetector(
          onTap: () => controller.selectMood(emoji),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 44,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: controller.selectedMoodEmoji.value == emoji
                    ? AppColors.primary
                    : AppColors.border,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  emoji,
                  style: AppTextStyles.labelMedium.copyWith(fontSize: 18),
                ),
              ],
            ),
          ),
        ));
  }
}
