// ignore_for_file: avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:englishfun/services/supabase_service.dart';
import 'package:englishfun/models/user_model.dart';
import 'package:englishfun/models/vocabulary_model.dart';
import 'package:englishfun/models/practice_model.dart';
import 'package:englishfun/models/daily_streak_model.dart';
import 'package:englishfun/models/user_progress_model.dart';
import 'package:englishfun/models/user_favorite_model.dart';
import 'package:englishfun/models/practice_attempt_model.dart';
import 'package:englishfun/models/quiz_result_model.dart';

// Auth State
final authStateProvider = StreamProvider<AuthState>((ref) {
  final supabase = SupabaseService();
  return supabase.client.auth.onAuthStateChange;
});

final currentUserProvider = FutureProvider<User?>((ref) async {
  final supabase = SupabaseService();
  return supabase.client.auth.currentUser;
});

final userProfileProvider = FutureProvider<UserModel?>((ref) async {
  try {
    final authState = await ref.read(authStateProvider.future);
    final supabase = SupabaseService();
    final sessionUser = authState.session?.user ?? supabase.client.auth.currentUser;

    if (sessionUser == null) {
      print('No authenticated user found');
      return null;
    }

    return await supabase.getUserProfile(sessionUser.id);
  } catch (e) {
    print('Error in userProfileProvider: $e');
    return null;
  }
});

// Auth Controller
final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  return AuthController(ref);
});

class AuthController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  final SupabaseService _supabaseService = SupabaseService();

  AuthController(this.ref) : super(const AsyncValue.data(null));

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _supabaseService.signUp(email: email, password: password, name: name);
      state = const AsyncValue.data(null);
      ref.invalidate(authStateProvider);
      ref.invalidate(userProfileProvider);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _supabaseService.signIn(email: email, password: password);
      state = const AsyncValue.data(null);
      ref.invalidate(authStateProvider);
      ref.invalidate(userProfileProvider);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await _supabaseService.signOut();
      state = const AsyncValue.data(null);
      ref.invalidate(authStateProvider);
      ref.invalidate(userProfileProvider);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateProfile({
    required String userId,
    String? name,
    String? avatar,
    int? totalWordsLearned,
    int? dailyStreak,
    double? accuracy,
    int? totalXP,
  }) async {
    try {
      await _supabaseService.updateUserProfile(
        userId: userId,
        name: name,
        avatar: avatar,
        totalWordsLearned: totalWordsLearned,
        dailyStreak: dailyStreak,
        accuracy: accuracy,
        totalXP: totalXP,
      );
      ref.invalidate(userProfileProvider);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }
}

// Vocabulary Providers
final vocabularyProvider = FutureProvider.family<List<VocabularyModel>, String?>((ref, level) async {
  final supabase = SupabaseService();
  return await supabase.getAllVocabulary(level: level);
});

final searchVocabularyProvider =
    FutureProvider.family<List<VocabularyModel>, String>((ref, query) async {
  final supabase = SupabaseService();
  return await supabase.searchVocabulary(query);
});

// Practice Questions Providers
final practiceQuestionsProvider =
    FutureProvider.family<List<PracticeQuestion>, Map<String, String?>>((ref, params) async {
  final supabase = SupabaseService();
  return await supabase.getPracticeQuestions(type: params['type'], level: params['level']);
});

// Daily Streaks Providers
final dailyStreakProvider =
    FutureProvider.family<DailyStreakModel?, String>((ref, userId) async {
  final supabase = SupabaseService();
  return await supabase.getDailyStreak(userId);
});

// User Progress Providers
final userProgressProvider = FutureProvider.family<UserProgressModel?, Map<String, String>>(
    (ref, params) async {
  final supabase = SupabaseService();
  return await supabase.getUserProgress(
    userId: params['userId']!,
    vocabularyId: params['vocabularyId']!,
  );
});

final userAllProgressProvider =
    FutureProvider.family<List<UserProgressModel>, String>((ref, userId) async {
  final supabase = SupabaseService();
  return await supabase.getUserAllProgress(userId);
});

// User Favorites Providers
final userFavoritesProvider =
    FutureProvider.family<List<UserFavoriteModel>, String>((ref, userId) async {
  final supabase = SupabaseService();
  return await supabase.getUserFavorites(userId);
});

// Practice Attempts Providers
final practiceAttemptsProvider = FutureProvider.family<List<PracticeAttemptModel>, String>(
    (ref, userId) async {
  final supabase = SupabaseService();
  return await supabase.getPracticeAttempts(userId: userId);
});

// Quiz Results Providers
final quizResultsProvider =
    FutureProvider.family<List<QuizResultModel>, String>((ref, userId) async {
  final supabase = SupabaseService();
  return await supabase.getUserQuizResults(userId);
});
