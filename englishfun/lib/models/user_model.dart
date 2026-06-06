class UserModel {
  final String id;
  final String name;
  final String email;
  final String avatar;
  final int totalWordsLearned;
  final int dailyStreak;
  final double accuracy;
  final int totalXP;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.totalWordsLearned,
    required this.dailyStreak,
    required this.accuracy,
    required this.totalXP,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String? ?? '👤',
      totalWordsLearned: json['totalWordsLearned'] as int? ?? 0,
      dailyStreak: json['dailyStreak'] as int? ?? 0,
      accuracy: (json['accuracy'] as num? ?? 0).toDouble(),
      totalXP: json['totalXP'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String? ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] as String? ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'avatar': avatar,
    'totalWordsLearned': totalWordsLearned,
    'dailyStreak': dailyStreak,
    'accuracy': accuracy,
    'totalXP': totalXP,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}
