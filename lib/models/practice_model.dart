class PracticeQuestion {
  final String id;
  final String type;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String? explanation;
  final String? level;
  final String? vocabularyId;

  PracticeQuestion({
    required this.id,
    required this.type,
    required this.question,
    required this.options,
    required this.correctAnswer,
    this.explanation,
    this.level,
    this.vocabularyId,
  });

  factory PracticeQuestion.fromJson(Map<String, dynamic> json) {
    return PracticeQuestion(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      question: json['question']?.toString() ?? '',
      options: (json['options'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      correctAnswer: json['correct_answer']?.toString() ??
          json['correctAnswer']?.toString() ??
          '',
      explanation: json['explanation']?.toString(),
      level: json['level']?.toString(),
      vocabularyId:
          json['vocabulary_id']?.toString() ?? json['vocabularyId']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'question': question,
        'options': options,
        'correct_answer': correctAnswer, // ✅ snake_case
        'explanation': explanation,
        'level': level,
        'vocabulary_id': vocabularyId, // ✅ snake_case
      };
}
