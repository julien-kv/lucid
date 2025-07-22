class PromptResponse {
  final int id;
  final String prompt;
  final String category;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PromptResponse({
    required this.id,
    required this.prompt,
    required this.category,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory PromptResponse.fromJson(Map<String, dynamic> json) {
    return PromptResponse(
      id: json['id'] as int,
      prompt: json['prompt'] as String,
      category: json['category'] as String,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prompt': prompt,
      'category': category,
      'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }
}

class PromptListResponse {
  final int id;
  final String prompt;
  final String category;
  final bool isActive;

  const PromptListResponse({
    required this.id,
    required this.prompt,
    required this.category,
    required this.isActive,
  });

  factory PromptListResponse.fromJson(Map<String, dynamic> json) {
    return PromptListResponse(
      id: json['id'] as int,
      prompt: json['prompt'] as String,
      category: json['category'] as String,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prompt': prompt,
      'category': category,
      'is_active': isActive,
    };
  }
}

class PromptCreate {
  final String prompt;
  final String category;

  const PromptCreate({
    required this.prompt,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'prompt': prompt,
      'category': category,
    };
  }
}

class PromptUpdate {
  final String? prompt;
  final String? category;
  final bool? isActive;

  const PromptUpdate({
    this.prompt,
    this.category,
    this.isActive,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (prompt != null) data['prompt'] = prompt;
    if (category != null) data['category'] = category;
    if (isActive != null) data['is_active'] = isActive;
    return data;
  }
}

class PromptCreateResponse {
  final String message;
  final PromptResponse prompt;

  const PromptCreateResponse({
    required this.message,
    required this.prompt,
  });

  factory PromptCreateResponse.fromJson(Map<String, dynamic> json) {
    return PromptCreateResponse(
      message: json['message'] as String,
      prompt: PromptResponse.fromJson(json['prompt'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'prompt': prompt.toJson(),
    };
  }
}

class PromptBulkCreate {
  final List<PromptCreate> prompts;

  const PromptBulkCreate({
    required this.prompts,
  });

  Map<String, dynamic> toJson() {
    return {
      'prompts': prompts.map((p) => p.toJson()).toList(),
    };
  }
}
