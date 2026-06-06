// ignore_for_file: avoid_print

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:englishfun/models/user_model.dart';
import 'package:englishfun/models/vocabulary_model.dart';
import 'package:englishfun/models/practice_model.dart';
import 'package:englishfun/models/daily_streak_model.dart';
import 'package:englishfun/models/user_progress_model.dart';
import 'package:englishfun/models/user_favorite_model.dart';
import 'package:englishfun/models/practice_attempt_model.dart';
import 'package:englishfun/models/quiz_result_model.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  late SupabaseClient client;

  static const String supabaseUrl = 'https://unnigtdgawmivdhqnnlw.supabase.co';
  static const String supabaseAnonKey = 'sb_publishable_d5WbziZO2hEV6FiU6juZkg_lnDb-i_O';

  SupabaseService._internal();

  factory SupabaseService() {
    return _instance;
  }

  Future<void> initialize() async {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
    client = Supabase.instance.client;
  }

  // ========== AUTHENTICATION ==========

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await client.auth.signUp(email: email, password: password);
      if (response.user != null) {
        await client.from('users').insert({
          'id': response.user!.id,
          'email': email,
          'name': name,
          'avatar': '👤',
          'totalWordsLearned': 0,
          'dailyStreak': 0,
          'accuracy': 0.0,
          'totalXP': 0,
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        });
        await client.from('daily_streaks').insert({
          'userId': response.user!.id,
          'streakCount': 0,
          'lastPracticeDate': DateTime.now().toIso8601String(),
          'createdAt': DateTime.now().toIso8601String(),
        });
      }
      return response;
    } catch (e) {
      print('Sign up failed: $e');
      rethrow;
    }
  }

  Future<AuthResponse> signIn({required String email, required String password}) async {
    try {
      final response = await client.auth.signInWithPassword(email: email, password: password);
      if (response.user != null) {
        await client
            .from('users')
            .update({'updatedAt': DateTime.now().toIso8601String()})
            .eq('id', response.user!.id);
      }
      return response;
    } catch (e) {
      print('Sign in failed: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await client.auth.signOut();
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  User? getCurrentUser() => client.auth.currentUser;
  bool isAuthenticated() => client.auth.currentUser != null;

  // ========== USER PROFILE ==========

  Future<UserModel?> getUserProfile(String userId) async {
    try {
      final response = await client.from('users').select().eq('id', userId).maybeSingle();
      if (response == null) return null;
      return UserModel.fromJson(response);
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }

  Future<void> updateUserProfile({
    required String userId,
    String? name,
    String? avatar,
    int? totalWordsLearned,
    int? dailyStreak,
    double? accuracy,
    int? totalXP,
  }) async {
    try {
      final updates = <String, dynamic>{'updatedAt': DateTime.now().toIso8601String()};
      if (name != null) updates['name'] = name;
      if (avatar != null) updates['avatar'] = avatar;
      if (totalWordsLearned != null) updates['totalWordsLearned'] = totalWordsLearned;
      if (dailyStreak != null) updates['dailyStreak'] = dailyStreak;
      if (accuracy != null) updates['accuracy'] = accuracy;
      if (totalXP != null) updates['totalXP'] = totalXP;
      await client.from('users').update(updates).eq('id', userId);
    } catch (e) {
      print('Failed to update user profile: $e');
    }
  }

  // ========== VOCABULARY ==========

  Future<List<VocabularyModel>> getAllVocabulary({String? level}) async {
    try {
      var query = client.from('vocabulary').select();
      if (level != null) query = query.eq('level', level);
      final response = await query;
      return (response as List).map((item) => VocabularyModel.fromJson(item)).toList();
    } catch (e) {
      print('Failed to fetch vocabulary: $e');
      return [];
    }
  }

  Future<VocabularyModel?> getVocabularyById(String vocabularyId) async {
    try {
      final response = await client.from('vocabulary').select().eq('id', vocabularyId).maybeSingle();
      if (response == null) return null;
      return VocabularyModel.fromJson(response);
    } catch (e) {
      print('Failed to fetch vocabulary: $e');
      return null;
    }
  }

  Future<List<VocabularyModel>> searchVocabulary(String query) async {
    try {
      final response = await client.from('vocabulary').select().ilike('word', '%$query%');
      return (response as List).map((item) => VocabularyModel.fromJson(item)).toList();
    } catch (e) {
      print('Failed to search vocabulary: $e');
      return [];
    }
  }

  // ========== PRACTICE QUESTIONS ==========

  Future<List<PracticeQuestion>> getPracticeQuestions({String? type, String? level}) async {
    try {
      var query = client.from('practice_questions').select();
      if (type != null) query = query.eq('type', type);
      if (level != null) query = query.eq('level', level);
      final response = await query;
      return (response as List).map((item) => PracticeQuestion.fromJson(item)).toList();
    } catch (e) {
      print('Failed to fetch practice questions: $e');
      return [];
    }
  }

  Future<PracticeQuestion?> getPracticeQuestionById(String questionId) async {
    try {
      final response =
          await client.from('practice_questions').select().eq('id', questionId).maybeSingle();
      if (response == null) return null;
      return PracticeQuestion.fromJson(response);
    } catch (e) {
      print('Failed to fetch practice question: $e');
      return null;
    }
  }

  // ========== DAILY STREAKS ==========

  Future<DailyStreakModel?> getDailyStreak(String userId) async {
    try {
      final response =
          await client.from('daily_streaks').select().eq('userId', userId).maybeSingle();
      if (response == null) return null;
      return DailyStreakModel.fromJson(response);
    } catch (e) {
      print('Failed to fetch daily streak: $e');
      return null;
    }
  }

  Future<void> updateDailyStreak({
    required String userId,
    required int streakCount,
    required DateTime lastPracticeDate,
  }) async {
    try {
      await client.from('daily_streaks').update({
        'streakCount': streakCount,
        'lastPracticeDate': lastPracticeDate.toIso8601String(),
      }).eq('userId', userId);
    } catch (e) {
      print('Failed to update daily streak: $e');
    }
  }

  // ========== USER PROGRESS ==========

  Future<UserProgressModel?> getUserProgress({
    required String userId,
    required String vocabularyId,
  }) async {
    try {
      final response = await client
          .from('user_progress')
          .select()
          .eq('userId', userId)
          .eq('vocabularyId', vocabularyId)
          .maybeSingle();
      if (response == null) return null;
      return UserProgressModel.fromJson(response);
    } catch (e) {
      print('Failed to fetch user progress: $e');
      return null;
    }
  }

  Future<List<UserProgressModel>> getUserAllProgress(String userId) async {
    try {
      final response = await client.from('user_progress').select().eq('userId', userId);
      return (response as List).map((item) => UserProgressModel.fromJson(item)).toList();
    } catch (e) {
      print('Failed to fetch user all progress: $e');
      return [];
    }
  }

  Future<void> updateUserProgress({
    required String userId,
    required String vocabularyId,
    required int attempts,
    required int correct,
    required bool mastered,
  }) async {
    try {
      final existing = await getUserProgress(userId: userId, vocabularyId: vocabularyId);
      if (existing != null) {
        await client.from('user_progress').update({
          'attempts': existing.attempts + attempts,
          'correct': existing.correct + correct,
          'mastered': mastered,
          'lastAttempt': DateTime.now().toIso8601String(),
        }).eq('userId', userId).eq('vocabularyId', vocabularyId);
      } else {
        await client.from('user_progress').insert({
          'id': '${userId}_${vocabularyId}_${DateTime.now().millisecondsSinceEpoch}',
          'userId': userId,
          'vocabularyId': vocabularyId,
          'attempts': attempts,
          'correct': correct,
          'mastered': mastered,
          'lastAttempt': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      print('Failed to update user progress: $e');
    }
  }

  // ========== USER FAVORITES ==========

  Future<List<UserFavoriteModel>> getUserFavorites(String userId) async {
    try {
      final response = await client.from('user_favorites').select().eq('userId', userId);
      return (response as List).map((item) => UserFavoriteModel.fromJson(item)).toList();
    } catch (e) {
      print('Failed to fetch favorites: $e');
      return [];
    }
  }

  Future<void> addToFavorites({required String userId, required String vocabularyId}) async {
    try {
      await client.from('user_favorites').insert({
        'id': '${userId}_${vocabularyId}_${DateTime.now().millisecondsSinceEpoch}',
        'userId': userId,
        'vocabularyId': vocabularyId,
        'createdAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Failed to add to favorites: $e');
    }
  }

  Future<void> removeFromFavorites({required String userId, required String vocabularyId}) async {
    try {
      await client
          .from('user_favorites')
          .delete()
          .eq('userId', userId)
          .eq('vocabularyId', vocabularyId);
    } catch (e) {
      print('Failed to remove from favorites: $e');
    }
  }

  // ========== PRACTICE ATTEMPTS ==========

  Future<List<PracticeAttemptModel>> getPracticeAttempts({
    required String userId,
    String? questionId,
  }) async {
    try {
      var query = client.from('practice_attempts').select().eq('userId', userId);
      if (questionId != null) query = query.eq('questionId', questionId);
      final response = await query;
      return (response as List).map((item) => PracticeAttemptModel.fromJson(item)).toList();
    } catch (e) {
      print('Failed to fetch practice attempts: $e');
      return [];
    }
  }

  Future<void> recordPracticeAttempt({
    required String userId,
    required String questionId,
    required String userAnswer,
    required bool isCorrect,
    required int xpGained,
  }) async {
    try {
      await client.from('practice_attempts').insert({
        'id': '${userId}_${questionId}_${DateTime.now().millisecondsSinceEpoch}',
        'userId': userId,
        'questionId': questionId,
        'userAnswer': userAnswer,
        'isCorrect': isCorrect,
        'xpGained': xpGained,
        'attemptedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Failed to record practice attempt: $e');
    }
  }

  // ========== QUIZ RESULTS ==========

  Future<List<QuizResultModel>> getUserQuizResults(String userId) async {
    try {
      final response = await client.from('quiz_results').select().eq('userId', userId);
      return (response as List).map((item) => QuizResultModel.fromJson(item)).toList();
    } catch (e) {
      print('Failed to fetch quiz results: $e');
      return [];
    }
  }

  Future<void> recordQuizResult({
    required String userId,
    required int score,
    required int totalQuestions,
    required double accuracy,
  }) async {
    try {
      await client.from('quiz_results').insert({
        'id': '${userId}_${DateTime.now().millisecondsSinceEpoch}',
        'userId': userId,
        'score': score,
        'totalQuestions': totalQuestions,
        'accuracy': accuracy,
        'completedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Failed to record quiz result: $e');
    }
  }
}
