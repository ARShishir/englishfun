class VocabularyModel {
  final String id;
  final String word;
  final String partOfSpeech;
  final String meaning;
  final String bangla;
  final List<String> synonyms;
  final List<String> examples;
  final String level;
  final bool isFavorite;

  VocabularyModel({
    required this.id,
    required this.word,
    required this.partOfSpeech,
    required this.meaning,
    required this.bangla,
    required this.synonyms,
    required this.examples,
    required this.level,
    this.isFavorite = false,
  });
}
