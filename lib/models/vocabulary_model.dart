class VocabularyModel {
  final String id;
  final String word;
  final String partOfSpeech;
  final String meaning;
  final String bangla;
  final List<String> synonyms;
  final List<String> examples;
  final String level;

  VocabularyModel({
    required this.id,
    required this.word,
    required this.partOfSpeech,
    required this.meaning,
    required this.bangla,
    required this.synonyms,
    required this.examples,
    required this.level,
  });

  factory VocabularyModel.fromJson(Map<String, dynamic> json) {
    return VocabularyModel(
      id: json['id']?.toString() ?? '',
      word: json['word']?.toString() ?? '',
      // ✅ Use snake_case from database
      partOfSpeech: json['part_of_speech']?.toString() ??
          json['partofspeech']?.toString() ??
          '',
      meaning: json['meaning']?.toString() ?? '',
      bangla: json['bangla']?.toString() ?? '',
      synonyms: (json['synonyms'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      examples: (json['examples'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      level: json['level']?.toString() ?? 'Beginner',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'word': word,
        'part_of_speech': partOfSpeech, // ✅ snake_case
        'meaning': meaning,
        'bangla': bangla,
        'synonyms': synonyms,
        'examples': examples,
        'level': level,
      };
}
