class QuizResultModel {
  final String id;
  final String userId;
  final int score;
  final int totalQuestions;
  final double accuracy;
  final DateTime completedAt;

  QuizResultModel({
    required this.id,
    required this.userId,
    required this.score,
    required this.totalQuestions,
    required this.accuracy,
    required this.completedAt,
  });

  factory QuizResultModel.fromJson(Map<String, dynamic> json) {
    return QuizResultModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      score: json['score'] as int? ?? 0,
      totalQuestions: json['totalQuestions'] as int? ?? 0,
      accuracy: (json['accuracy'] as num? ?? 0).toDouble(),
      completedAt: DateTime.parse(json['completedAt'] as String? ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'score': score,
    'totalQuestions': totalQuestions,
    'accuracy': accuracy,
    'completedAt': completedAt.toIso8601String(),
  };
}
