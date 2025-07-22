import 'package:get/get.dart';

import '../../core/api/api_client.dart';
import '../../core/api/api_config.dart';
import '../models/api/prompt_models.dart';

class PromptService extends GetxService {
  final ApiClient _apiClient = ApiClient.instance;

  /// Get all prompts with optional filtering
  Future<List<PromptListResponse>> getPrompts({
    int skip = 0,
    int limit = 50,
    String? category,
    bool activeOnly = true,
  }) async {
    final queryParams = <String, dynamic>{
      'skip': skip,
      'limit': limit,
      'active_only': activeOnly,
    };

    if (category != null && category.isNotEmpty) {
      queryParams['category'] = category;
    }

    final response = await _apiClient.get(
      ApiConfig.prompts,
      queryParameters: queryParams,
    );

    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((item) => PromptListResponse.fromJson(item)).toList();
  }

  /// Get prompts by category
  Future<List<PromptListResponse>> getPromptsByCategory(
    String category, {
    int skip = 0,
    int limit = 20,
  }) async {
    final response = await _apiClient.get(
      ApiConfig.promptsByCategory(category),
      queryParameters: {
        'skip': skip,
        'limit': limit,
      },
    );

    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((item) => PromptListResponse.fromJson(item)).toList();
  }

  /// Get a specific prompt by ID
  Future<PromptResponse> getPromptById(int promptId) async {
    final response = await _apiClient.get(ApiConfig.promptById(promptId));
    return PromptResponse.fromJson(response.data);
  }

  /// Get a random prompt, optionally from a specific category
  Future<String> getRandomPrompt({String? category}) async {
    final queryParams = <String, dynamic>{};
    if (category != null && category.isNotEmpty) {
      queryParams['category'] = category;
    }

    final response = await _apiClient.get(
      ApiConfig.randomPrompt,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    return response.data as String;
  }

  /// Get all available prompt categories
  Future<List<String>> getPromptCategories() async {
    final response = await _apiClient.get(ApiConfig.promptCategories);

    if (response.data is Map<String, dynamic>) {
      final data = (response.data as Map<String, dynamic>)['categories'] as List<dynamic>;

      return data.map((item) => item.toString()).toList();
    } else {
      return [response.data.toString()];
    }
  }

  /// Create a new prompt
  Future<PromptCreateResponse> createPrompt({
    required String prompt,
    required String category,
  }) async {
    final createData = PromptCreate(
      prompt: prompt,
      category: category,
    );

    final response = await _apiClient.post(
      ApiConfig.prompts,
      data: createData.toJson(),
    );

    return PromptCreateResponse.fromJson(response.data);
  }

  /// Create multiple prompts in bulk
  Future<PromptCreateResponse> createPromptsBulk({
    required List<PromptCreate> prompts,
  }) async {
    final bulkData = PromptBulkCreate(prompts: prompts);

    final response = await _apiClient.post(
      ApiConfig.prompts,
      data: bulkData.toJson(),
    );

    return PromptCreateResponse.fromJson(response.data);
  }

  /// Update a prompt
  Future<PromptResponse> updatePrompt({
    required int promptId,
    String? prompt,
    String? category,
    bool? isActive,
  }) async {
    final updateData = PromptUpdate(
      prompt: prompt,
      category: category,
      isActive: isActive,
    );

    final response = await _apiClient.put(
      ApiConfig.promptById(promptId),
      data: updateData.toJson(),
    );

    return PromptResponse.fromJson(response.data);
  }

  /// Delete a prompt
  Future<String> deletePrompt(int promptId) async {
    final response = await _apiClient.delete(ApiConfig.promptById(promptId));
    return response.data as String;
  }
}
