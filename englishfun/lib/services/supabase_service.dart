// ignore_for_file: avoid_print

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:englishfun/models/user_model.dart';
import 'package:englishfun/models/vocabulary_model.dart';
// practice_model not required here after refactor

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  late SupabaseClient client;

  // Supabase credentials
  static const String supabaseUrl = 'https://llmdumbnmsxfnvdgxchn.supabase.co';
  static const String supabaseAnonKey = 'sb_publishable_eI1xXiAWxyPJ_G80QKy7NQ_Z-WFgEpa';

  SupabaseService._internal();

  factory SupabaseService() {
    return _instance;
  }

  // Initialize Supabase
  Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
    client = Supabase.instance.client;
  }

  // ========================================
  // AUTHENTICATION METHODS
  // ========================================

  // Sign up with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await client.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        print('SignUp auth created user: ${response.user!.id}');
        try {
          // Create user profile in users table
          await client.from('users').insert({
            'id': response.user!.id,
            'email': email,
            'name': name,
            'avatar': '👤',
          });

          print('Inserted user profile into users table for id: ${response.user!.id}');
          // Create daily streak record
          await client.from('daily_streaks').insert({
            'user_id': response.user!.id,
            'current_streak': 0,
            'longest_streak': 0,
          });
        } catch (e) {
          print('Error creating user profile: $e');
        }
      }

      return response;
    } catch (e) {
      print('Sign up failed: $e');
      rethrow;
    }
  }

  // Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        try {
          await client.from('users').update({
            'last_login': DateTime.now().toIso8601String(),
          }).eq('id', response.user!.id);
        } catch (e) {
          print('Error updating last login: $e');
        }
      }

      return response;
    } catch (e) {
      print('Sign in failed: $e');
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await client.auth.signOut();
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  // Get current user
  User? getCurrentUser() {
    return client.auth.currentUser;
  }

  // Check if user is authenticated
  bool isAuthenticated() {
    return client.auth.currentUser != null;
  }

  // ========================================
  // USER PROFILE METHODS
  // ========================================

  // Get user profile
  Future<UserModel?> getUserProfile(String userId) async {
    try {
      final response = await client
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response == null) return null;

      return UserModel(
        id: response['id'],
        name: response['name'],
        email: response['email'],
        avatar: response['avatar'] ?? '👤',
        totalWordsLearned: response['total_words_learned'] ?? 0,
        dailyStreak: response['daily_streak'] ?? 0,
        accuracy: (response['accuracy'] ?? 0.0).toDouble(),
        totalXP: response['total_xp'] ?? 0,
      );
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }

  // Update user profile
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
      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (avatar != null) updates['avatar'] = avatar;
      if (totalWordsLearned != null) updates['total_words_learned'] = totalWordsLearned;
      if (dailyStreak != null) updates['daily_streak'] = dailyStreak;
      if (accuracy != null) updates['accuracy'] = accuracy;
      if (totalXP != null) updates['total_xp'] = totalXP;

      await client.from('users').update(updates).eq('id', userId);
    } catch (e) {
      print('Failed to update user profile: $e');
    }
  }

  // ========================================
  // VOCABULARY METHODS
  // ========================================

  // Get all vocabulary
  Future<List<VocabularyModel>> getAllVocabulary({String? level}) async {
    try {
      var query = client.from('vocabulary').select();

      if (level != null) {
        query = query.eq('level', level);
      }

      final response = await query;

      return (response as List).map((item) {
        return VocabularyModel(
          id: item['id'] ?? '',
          word: item['word'] ?? '',
          partOfSpeech: item['part_of_speech'] ?? '',
          meaning: item['meaning'] ?? '',
          bangla: item['bangla_translation'] ?? '',
          synonyms: item['synonyms'] != null ? List<String>.from(item['synonyms']) : [],
          examples: item['examples'] != null ? List<String>.from(item['examples']) : [],
          level: item['level'] ?? 'Beginner',
          isFavorite: false,
        );
      }).toList();
    } catch (e) {
      print('Failed to fetch vocabulary: $e');
      return [];
    }
  }

  // Search vocabulary
  Future<List<VocabularyModel>> searchVocabulary(String query) async {
    try {
      final response = await client
          .from('vocabulary')
          .select()
          .ilike('word', '%$query%');

      return (response as List).map((item) {
        return VocabularyModel(
          id: item['id'] ?? '',
          word: item['word'] ?? '',
          partOfSpeech: item['part_of_speech'] ?? '',
          meaning: item['meaning'] ?? '',
          bangla: item['bangla_translation'] ?? '',
          synonyms: item['synonyms'] != null ? List<String>.from(item['synonyms']) : [],
          examples: item['examples'] != null ? List<String>.from(item['examples']) : [],
          level: item['level'] ?? 'Beginner',
          isFavorite: false,
        );
      }).toList();
    } catch (e) {
      print('Failed to search vocabulary: $e');
      return [];
    }
  }

  // ========================================
  // PRACTICE QUESTIONS METHODS
  // ========================================

  // Get practice questions by type
  Future<List<dynamic>> getPracticeQuestions({String? type, String? level}) async {
    try {
      var query = client.from('practice_questions').select();

      if (type != null) {
        query = query.eq('question_type', type);
      }

      if (level != null) {
        query = query.eq('difficulty_level', level);
      }

      final response = await query;
      print('Fetched ${(response as List).length} practice questions');
      return response as List<dynamic>;
    } catch (e) {
      print('Failed to fetch practice questions: $e');
      return [];
    }
  }

  // ========================================
  // USER PROGRESS METHODS
  // ========================================

  // Get user progress for a vocabulary
  Future<Map<String, dynamic>?> getUserProgress({
    required String userId,
    required String vocabularyId,
  }) async {
    try {
      final response = await client
          .from('user_progress')
          .select()
          .eq('user_id', userId)
          .eq('vocabulary_id', vocabularyId)
          .maybeSingle();

      return response;
    } catch (e) {
      print('Failed to fetch user progress: $e');
      return null;
    }
  }

  // Update or insert user progress
  Future<void> updateUserProgress({
    required String userId,
    required String vocabularyId,
    int? timesCompleted,
    int? correctAttempts,
    int? totalAttempts,
    double? accuracyRate,
  }) async {
    try {
      final existing = await getUserProgress(
        userId: userId,
        vocabularyId: vocabularyId,
      );

      if (existing != null) {
        await client
            .from('user_progress')
            .update({
              'times_practiced': (existing['times_practiced'] ?? 0) + 1,
              'correct_attempts': correctAttempts ?? existing['correct_attempts'],
              'total_attempts': (existing['total_attempts'] ?? 0) + (totalAttempts ?? 1),
              'accuracy_rate': accuracyRate,
              'last_practiced': DateTime.now().toIso8601String(),
            })
            .eq('user_id', userId)
            .eq('vocabulary_id', vocabularyId);
      } else {
        await client.from('user_progress').insert({
          'user_id': userId,
          'vocabulary_id': vocabularyId,
          'times_practiced': 1,
          'correct_attempts': correctAttempts ?? 0,
          'total_attempts': totalAttempts ?? 1,
          'accuracy_rate': accuracyRate ?? 0.0,
          'last_practiced': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      print('Failed to update user progress: $e');
    }
  }

  // ========================================
  // FAVORITES METHODS
  // ========================================

  // Add to favorites
  Future<void> addToFavorites({
    required String userId,
    required String vocabularyId,
  }) async {
    try {
      await client.from('user_favorites').insert({
        'user_id': userId,
        'vocabulary_id': vocabularyId,
      });
    } catch (e) {
      print('Failed to add to favorites: $e');
    }
  }

  // Remove from favorites
  Future<void> removeFromFavorites({
    required String userId,
    required String vocabularyId,
  }) async {
    try {
      await client
          .from('user_favorites')
          .delete()
          .eq('user_id', userId)
          .eq('vocabulary_id', vocabularyId);
    } catch (e) {
      print('Failed to remove from favorites: $e');
    }
  }

  // Get user favorites
  Future<List<String>> getUserFavorites(String userId) async {
    try {
      final response = await client
          .from('user_favorites')
          .select('vocabulary_id')
          .eq('user_id', userId);

      return (response as List).map((item) => item['vocabulary_id'].toString()).toList();
    } catch (e) {
      print('Failed to fetch favorites: $e');
      return [];
    }
  }

  // ========================================
  // DAILY STREAK METHODS
  // ========================================

  // Get user's daily streak
  Future<Map<String, dynamic>?> getDailyStreak(String userId) async {
    try {
      final response = await client
          .from('daily_streaks')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      return response;
    } catch (e) {
      print('Failed to fetch daily streak: $e');
      return null;
    }
  }

  // Update daily streak
  Future<void> updateDailyStreak({
    required String userId,
    required int currentStreak,
    required int longestStreak,
  }) async {
    try {
      await client
          .from('daily_streaks')
          .update({
            'current_streak': currentStreak,
            'longest_streak': longestStreak,
            'last_activity_date': DateTime.now().toString().split(' ')[0],
          })
          .eq('user_id', userId);
    } catch (e) {
      print('Failed to update daily streak: $e');
    }
  }

  // ========================================
  // HELPER METHODS
  // ========================================
}
