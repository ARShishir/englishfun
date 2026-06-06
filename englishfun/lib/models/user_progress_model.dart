class UserProgressModel {
  final String id;
  final String userId;
  final String vocabularyId;
  final int attempts;
  final int correct;
  final bool mastered;
  final DateTime lastAttempt;

  UserProgressModel({
    required this.id,
    required this.userId,
    required this.vocabularyId,
    required this.attempts,
    required this.correct,
    required this.mastered,
    required this.lastAttempt,
  });

  factory UserProgressModel.fromJson(Map<String, dynamic> json) {
    return UserProgressModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      vocabularyId: json['vocabularyId'] as String,
      attempts: json['attempts'] as int? ?? 0,
      correct: json['correct'] as int? ?? 0,
      mastered: json['mastered'] as bool? ?? false,
      lastAttempt: DateTime.parse(json['lastAttempt'] as String? ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'vocabularyId': vocabularyId,
    'attempts': attempts,
    'correct': correct,
    'mastered': mastered,
    'lastAttempt': lastAttempt.toIso8601String(),
  };
}
