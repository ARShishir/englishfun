class DailyStreakModel {
  final String id;
  final String userId;
  final int streakCount;
  final DateTime lastPracticeDate;
  final DateTime createdAt;

  DailyStreakModel({
    required this.id,
    required this.userId,
    required this.streakCount,
    required this.lastPracticeDate,
    required this.createdAt,
  });

  factory DailyStreakModel.fromJson(Map<String, dynamic> json) {
    return DailyStreakModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      streakCount: json['streakCount'] as int? ?? 0,
      lastPracticeDate: DateTime.parse(json['lastPracticeDate'] as String? ?? DateTime.now().toIso8601String()),
      createdAt: DateTime.parse(json['createdAt'] as String? ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'streakCount': streakCount,
    'lastPracticeDate': lastPracticeDate.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
  };
}
