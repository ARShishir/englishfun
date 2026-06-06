class PracticeAttemptModel {
  final String id;
  final String userId;
  final String questionId;
  final String userAnswer;
  final bool isCorrect;
  final int xpGained;
  final DateTime attemptedAt;

  PracticeAttemptModel({
    required this.id,
    required this.userId,
    required this.questionId,
    required this.userAnswer,
    required this.isCorrect,
    required this.xpGained,
    required this.attemptedAt,
  });

  factory PracticeAttemptModel.fromJson(Map<String, dynamic> json) {
    return PracticeAttemptModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      questionId: json['questionId'] as String,
      userAnswer: json['userAnswer'] as String,
      isCorrect: json['isCorrect'] as bool? ?? false,
      xpGained: json['xpGained'] as int? ?? 0,
      attemptedAt: DateTime.parse(json['attemptedAt'] as String? ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'questionId': questionId,
    'userAnswer': userAnswer,
    'isCorrect': isCorrect,
    'xpGained': xpGained,
    'attemptedAt': attemptedAt.toIso8601String(),
  };
}
