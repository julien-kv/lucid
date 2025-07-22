import 'package:get/get.dart';

import '../../../core/exceptions/api_exceptions.dart';
import '../../../data/models/journal_prompt.dart';
import '../../../data/services/prompt_service.dart';

class PromptsController extends GetxController {
  final categories = <String>[].obs;
  final selectedCategory = 'All'.obs;
  final prompts = <JournalPrompt>[].obs;
  final isLoading = false.obs;
  final isLoadingCategory = false.obs;

  final PromptService _promptService = Get.find<PromptService>();

  @override
  void onInit() {
    super.onInit();
    loadCategories();
    loadPrompts();
  }

  Future<void> loadCategories() async {
    try {
      final apiCategories = await _promptService.getPromptCategories();
      categories.assignAll(['All', ...apiCategories]);
    } catch (e) {
      categories.assignAll(['All']);
    }
  }

  Future<void> loadPrompts() async {
    try {
      isLoading.value = true;
      final apiPrompts = await _promptService.getPrompts(limit: 100);
      final convertedPrompts = apiPrompts
          .map((apiPrompt) => JournalPrompt(
                id: apiPrompt.id.toString(),
                title: apiPrompt.prompt,
                description: '', // No description
                category: PromptCategory.values.firstWhere((e) => e.name == apiPrompt.category),
                isFeatured: false,
              ))
          .toList();
      prompts.assignAll(convertedPrompts);
    } on NetworkException {
      Get.snackbar('Network Error', 'Please check your internet connection',
          snackPosition: SnackPosition.TOP);
      prompts.clear();
    } on ApiException catch (e) {
      Get.snackbar('Error', 'Failed to load prompts: ${e.message}',
          snackPosition: SnackPosition.TOP);
      prompts.clear();
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred', snackPosition: SnackPosition.TOP);
      prompts.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> selectCategory(String category) async {
    selectedCategory.value = category;
    if (category == 'All' || category.isEmpty) {
      await loadPrompts();
    } else {
      await loadPromptsByCategory(category);
    }
  }

  Future<void> loadPromptsByCategory(String category) async {
    try {
      isLoadingCategory.value = true;
      final apiPrompts = await _promptService.getPromptsByCategory(category);
      final convertedPrompts = apiPrompts
          .map((apiPrompt) => JournalPrompt(
                id: apiPrompt.id.toString(),
                title: apiPrompt.prompt,
                description: '', // No description
                category: PromptCategory.values.firstWhere((e) => e.name == apiPrompt.category),
                isFeatured: false,
              ))
          .toList();
      prompts.assignAll(convertedPrompts);
    } catch (e) {
      prompts.clear();
    } finally {
      isLoadingCategory.value = false;
    }
  }

  List<JournalPrompt> get filteredPrompts => prompts;

  void selectPrompt(JournalPrompt prompt) {
    Get.toNamed('/new-entry', arguments: {'prompt': prompt});
  }

  Future<void> refreshPrompts() async {
    if (selectedCategory.value == 'All' || selectedCategory.value.isEmpty) {
      await loadPrompts();
    } else {
      await loadPromptsByCategory(selectedCategory.value);
    }
  }

  Future<void> getRandomPrompt() async {
    try {
      final randomPromptText = await _promptService.getRandomPrompt(
        category: selectedCategory.value == 'All' ? null : selectedCategory.value,
      );
      final randomPrompt = JournalPrompt(
        id: 'random_${DateTime.now().millisecondsSinceEpoch}',
        title: randomPromptText,
        description: '',
        category: PromptCategory.values.firstWhere((e) => e.name == selectedCategory.value),
      );
      selectPrompt(randomPrompt);
    } on NetworkException {
      Get.snackbar('Network Error', 'Please check your internet connection',
          snackPosition: SnackPosition.TOP);
    } on ApiException catch (e) {
      Get.snackbar('Error', 'Failed to get random prompt: ${e.message}',
          snackPosition: SnackPosition.TOP);
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred', snackPosition: SnackPosition.TOP);
    }
  }
}
