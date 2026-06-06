class VocabularyModel {
  final String id;
  final String word;
  final String partOfSpeech;
  final String meaning;
  final String bangla;
  final List<String> synonyms;
  final List<String> examples;
  final String level;
  final DateTime createdAt;

  VocabularyModel({
    required this.id,
    required this.word,
    required this.partOfSpeech,
    required this.meaning,
    required this.bangla,
    required this.synonyms,
    required this.examples,
    required this.level,
    required this.createdAt,
  });

  factory VocabularyModel.fromJson(Map<String, dynamic> json) {
    return VocabularyModel(
      id: json['id'] as String,
      word: json['word'] as String,
      partOfSpeech: json['partOfSpeech'] as String,
      meaning: json['meaning'] as String,
      bangla: json['bangla'] as String,
      synonyms: List<String>.from(json['synonyms'] as List? ?? []),
      examples: List<String>.from(json['examples'] as List? ?? []),
      level: json['level'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String? ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'word': word,
    'partOfSpeech': partOfSpeech,
    'meaning': meaning,
    'bangla': bangla,
    'synonyms': synonyms,
    'examples': examples,
    'level': level,
    'createdAt': createdAt.toIso8601String(),
  };
}
