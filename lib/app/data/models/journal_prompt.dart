enum PromptCategory {
  all,
  gratitude,
  selfReflection,
  emotionalProcessing,
}

extension PromptCategoryExtension on PromptCategory {
  String get displayName {
    switch (this) {
      case PromptCategory.all:
        return 'All';
      case PromptCategory.gratitude:
        return 'Gratitude';
      case PromptCategory.selfReflection:
        return 'Self-Reflection';
      case PromptCategory.emotionalProcessing:
        return 'Emotional Processing';
    }
  }
}

class JournalPrompt {
  final String id;
  final String title;
  final String description;
  final PromptCategory category;
  final bool isFeatured;

  const JournalPrompt({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.isFeatured = false,
  });

  static const List<JournalPrompt> samplePrompts = [
    JournalPrompt(
      id: '1',
      title: 'What are you most grateful for today?',
      description: 'Reflect on the positive aspects of your day and express gratitude.',
      category: PromptCategory.gratitude,
      isFeatured: true,
    ),
    JournalPrompt(
      id: '2',
      title: 'What is one thing you can do today to make yourself happy?',
      description: 'Think about small actions that can bring joy to your day.',
      category: PromptCategory.selfReflection,
    ),
    JournalPrompt(
      id: '3',
      title: 'How are you feeling today?',
      description: 'Take a moment to check in with your emotions and feelings.',
      category: PromptCategory.emotionalProcessing,
    ),
    JournalPrompt(
      id: '4',
      title: 'What is one thing you appreciate about your life?',
      description: 'Consider the aspects of your life that you value most.',
      category: PromptCategory.gratitude,
    ),
    JournalPrompt(
      id: '5',
      title: 'What challenge are you facing and how can you overcome it?',
      description: 'Identify current challenges and brainstorm potential solutions.',
      category: PromptCategory.selfReflection,
    ),
    JournalPrompt(
      id: '6',
      title: 'Describe a moment that made you smile recently.',
      description: 'Recall and describe a recent experience that brought you joy.',
      category: PromptCategory.emotionalProcessing,
    ),
  ];
}
