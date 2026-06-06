class UserFavoriteModel {
  final String id;
  final String userId;
  final String vocabularyId;
  final DateTime createdAt;

  UserFavoriteModel({
    required this.id,
    required this.userId,
    required this.vocabularyId,
    required this.createdAt,
  });

  factory UserFavoriteModel.fromJson(Map<String, dynamic> json) {
    return UserFavoriteModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      vocabularyId: json['vocabularyId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String? ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'vocabularyId': vocabularyId,
    'createdAt': createdAt.toIso8601String(),
  };
}
