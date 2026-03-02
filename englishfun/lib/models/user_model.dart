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
}
