enum PracticeType { sentenceArrangement, fillBlank, spelling }

class PracticeQuestion {
  final String id;
  final PracticeType type;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String explanation;
  final String level;
  final String vocabularyId;
  final DateTime createdAt;

  PracticeQuestion({
    required this.id,
    required this.type,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.level,
    required this.vocabularyId,
    required this.createdAt,
  });

  factory PracticeQuestion.fromJson(Map<String, dynamic> json) {
    return PracticeQuestion(
      id: json['id'] as String,
      type: PracticeType.values.byName(json['type'] as String),
      question: json['question'] as String,
      options: List<String>.from(json['options'] as List? ?? []),
      correctAnswer: json['correctAnswer'] as String,
      explanation: json['explanation'] as String,
      level: json['level'] as String,
      vocabularyId: json['vocabularyId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String? ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'question': question,
    'options': options,
    'correctAnswer': correctAnswer,
    'explanation': explanation,
    'level': level,
    'vocabularyId': vocabularyId,
    'createdAt': createdAt.toIso8601String(),
  };
}
