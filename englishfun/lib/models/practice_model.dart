enum PracticeType { sentenceArrangement, fillBlank, spelling }

class PracticeQuestion {
  final String id;
  final PracticeType type;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String explanation;

  PracticeQuestion({
    required this.id,
    required this.type,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  });
}
