class JournalEntry {
  final String id;
  final String userId; // Foreign Key linking note to Firebase Auth User UID
  final String title;
  final String content;
  final String mood;
  final DateTime date;

  JournalEntry({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.mood,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'title': title,
        'content': content,
        'mood': mood,
        'date': date.toIso8601String(),
      };

  factory JournalEntry.fromJson(Map<String, dynamic> json) => JournalEntry(
        id: json['id'] ?? '',
        userId: json['userId'] ?? '',
        title: json['title'] ?? '',
        content: json['content'] ?? '',
        mood: json['mood'] ?? 'Suspect Theory',
        date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      );
}