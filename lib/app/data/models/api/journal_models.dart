import '../user_profile.dart';

// Journal API Models

class JournalCreate {
  final String title;
  final String content;
  final List<String>? images;
  final String? audio;
  final String mood;
  final String? summary;

  JournalCreate({
    required this.title,
    required this.content,
    this.images,
    this.audio,
    required this.mood,
    this.summary,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        if (images != null) 'images': images,
        if (audio != null) 'audio': audio,
        'mood': mood,
        if (summary != null) 'summary': summary,
      };
}

class JournalUpdate {
  final String? title;
  final String? content;
  final List<String>? images;
  final String? audio;
  final String? mood;
  final String? summary;

  JournalUpdate({
    this.title,
    this.content,
    this.images,
    this.audio,
    this.mood,
    this.summary,
  });

  Map<String, dynamic> toJson() => {
        if (title != null) 'title': title,
        if (content != null) 'content': content,
        if (images != null) 'images': images,
        if (audio != null) 'audio': audio,
        if (mood != null) 'mood': mood,
        if (summary != null) 'summary': summary,
      };
}

class JournalResponse {
  final int id;
  final String title;
  final String content;
  final List<String>? images;
  final String? audio;
  final String mood;
  final String? summary;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int createdBy;
  final UserProfile? creator;

  JournalResponse({
    required this.id,
    required this.title,
    required this.content,
    this.images,
    this.audio,
    required this.mood,
    this.summary,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    this.creator,
  });

  factory JournalResponse.fromJson(Map<String, dynamic> json) => JournalResponse(
        id: json['id'],
        title: json['title'],
        content: json['content'],
        images: json['images'] != null ? List<String>.from(json['images']) : null,
        audio: json['audio']??'',
        mood: json['mood']??'',
        summary: json['summary']??'',
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        createdBy: json['created_by'],
        creator: json['creator'] != null ? UserProfile.fromJson(json['creator']) : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        if (images != null) 'images': images,
        if (audio != null) 'audio': audio,
        'mood': mood,
        if (summary != null) 'summary': summary,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'created_by': createdBy,
        if (creator != null) 'creator': creator!.toJson(),
      };
}

class JournalListResponse {
  final int id;
  final String title;
  final String content;
  final String mood;
  final String? summary;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int createdBy;

  JournalListResponse({
    required this.id,
    required this.title,
    required this.content,
    required this.mood,
    this.summary,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
  });

  factory JournalListResponse.fromJson(Map<String, dynamic> json) => JournalListResponse(
        id: json['id'],
        title: json['title'],
        content: json['content'],
        mood: json['mood']??'',
        summary: json['summary'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        createdBy: json['created_by'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'mood': mood,
        if (summary != null) 'summary': summary,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'created_by': createdBy,
      };
}

class JournalCreateResponse {
  final String message;
  final JournalResponse journal;

  JournalCreateResponse({
    required this.message,
    required this.journal,
  });

  factory JournalCreateResponse.fromJson(Map<String, dynamic> json) => JournalCreateResponse(
        message: json['message'],
        journal: JournalResponse.fromJson(json['journal']),
      );

  Map<String, dynamic> toJson() => {
        'message': message,
        'journal': journal.toJson(),
      };
}

class MoodStatistics {
  final Map<String, int> moodCounts;

  MoodStatistics({required this.moodCounts});

  factory MoodStatistics.fromJson(Map<String, dynamic> json) => MoodStatistics(
        moodCounts: Map<String, int>.from(json),
      );

  Map<String, dynamic> toJson() => moodCounts;
}
