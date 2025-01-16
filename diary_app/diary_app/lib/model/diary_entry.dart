// models/diary_entry.dart
class DiaryEntry {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;

  DiaryEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  factory DiaryEntry.fromJson(Map<String, dynamic> json) {
    return DiaryEntry(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}