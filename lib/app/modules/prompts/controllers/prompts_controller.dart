import 'package:get/get.dart';

import '../../../data/models/journal_prompt.dart';

class PromptsController extends GetxController {
  final selectedCategory = PromptCategory.all.obs;
  final prompts = <JournalPrompt>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadPrompts();
  }

  void loadPrompts() {
    prompts.value = JournalPrompt.samplePrompts;
  }

  List<JournalPrompt> get filteredPrompts {
    if (selectedCategory.value == PromptCategory.all) {
      return prompts.where((prompt) => !prompt.isFeatured).toList();
    }
    return prompts
        .where((prompt) => prompt.category == selectedCategory.value && !prompt.isFeatured)
        .toList();
  }

  JournalPrompt? get featuredPrompt {
    return prompts.firstWhereOrNull((prompt) => prompt.isFeatured);
  }

  void selectCategory(PromptCategory category) {
    selectedCategory.value = category;
  }

  void selectPrompt(JournalPrompt prompt) {
    // Navigate to new entry with selected prompt
    Get.toNamed('/new-entry', arguments: {'prompt': prompt});
  }
}
