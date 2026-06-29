class UserModel {
  final String id;
  final String name;
  final String email;
  final String avatar;
  final int totalWordsLearned;
  final int dailyStreak;
  final double accuracy;
  final int totalXP;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.totalWordsLearned,
    required this.dailyStreak,
    required this.accuracy,
    required this.totalXP,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      avatar: json['avatar']?.toString() ?? '👤',
      // ✅ Use snake_case from database
      totalWordsLearned: json['total_words_learned'] as int? ??
          json['totalwordslearned'] as int? ??
          0,
      dailyStreak:
          json['daily_streak'] as int? ?? json['dailystreak'] as int? ?? 0,
      accuracy: (json['accuracy'] as num?)?.toDouble() ?? 0.0,
      totalXP: json['total_xp'] as int? ?? json['totalxp'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'avatar': avatar,
        'total_words_learned': totalWordsLearned, // ✅ snake_case
        'daily_streak': dailyStreak, // ✅ snake_case
        'accuracy': accuracy,
        'total_xp': totalXP, // ✅ snake_case
      };
}
