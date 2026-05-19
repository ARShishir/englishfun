// ignore_for_file: avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:englishfun/services/supabase_service.dart';
import 'package:englishfun/models/user_model.dart';

// Providers for authentication state management

// Current user auth state
final authStateProvider = StreamProvider<AuthState>((ref) {
  final supabase = SupabaseService();
  return supabase.client.auth.onAuthStateChange;
});

// Current authenticated user - gets the actual auth user
final currentUserProvider = FutureProvider<User?>((ref) async {
  final supabase = SupabaseService();
  return supabase.client.auth.currentUser;
});

// Current user profile - fetches from database using current user ID
final userProfileProvider = FutureProvider<UserModel?>((ref) async {
  try {
    // Wait for the first auth state emission to ensure session is available
    final authState = await ref.read(authStateProvider.future);

    final supabase = SupabaseService();

    // Prefer session user from authState, fallback to currentUser
    final sessionUser = authState.session?.user ?? supabase.client.auth.currentUser;

    if (sessionUser == null) {
      print('No authenticated user found');
      return null;
    }

    print('Fetching profile for user: ${sessionUser.id}');
    final profile = await supabase.getUserProfile(sessionUser.id);

    if (profile == null) {
      print('User profile not found in database for user: ${sessionUser.id}');
    }

    return profile;
  } catch (e) {
    print('Error in userProfileProvider: $e');
    return null;
  }
});

// Authentication controller
final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  return AuthController(ref);
});

class AuthController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  final SupabaseService _supabaseService = SupabaseService();

  AuthController(this.ref) : super(const AsyncValue.data(null));

  // Sign up with email and password
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    state = const AsyncValue.loading();
    try {
      final response = await _supabaseService.signUp(
        email: email,
        password: password,
        name: name,
      );

      if (response.user != null) {
        state = const AsyncValue.data(null);
        // Invalidate all auth-related providers
        ref.invalidate(authStateProvider);
        ref.invalidate(currentUserProvider);
        ref.invalidate(userProfileProvider);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // Sign in with email and password
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      final response = await _supabaseService.signIn(
        email: email,
        password: password,
      );

      if (response.user != null) {
        state = const AsyncValue.data(null);
        // Invalidate all auth-related providers to force refresh
        ref.invalidate(authStateProvider);
        ref.invalidate(currentUserProvider);
        ref.invalidate(userProfileProvider);
        
        print('Sign in successful for user: ${response.user!.id}');
      }
    } catch (e, st) {
      print('Sign in error: $e');
      state = AsyncValue.error(e, st);
    }
  }

  // Sign out
  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await _supabaseService.signOut();
      state = const AsyncValue.data(null);
      ref.invalidate(authStateProvider);
      ref.invalidate(currentUserProvider);
      ref.invalidate(userProfileProvider);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // Update user profile
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

// Vocabulary provider
final vocabularyProvider = FutureProvider.family<List<dynamic>, String?>((ref, level) async {
  final supabase = SupabaseService();
  return await supabase.getAllVocabulary(level: level);
});

// Search vocabulary provider
final searchVocabularyProvider = FutureProvider.family<List<dynamic>, String>((ref, query) async {
  final supabase = SupabaseService();
  return await supabase.searchVocabulary(query);
});

// Practice questions provider
final practiceQuestionsProvider = FutureProvider.family<List<dynamic>, Map<String, String?>>((ref, params) async {
  final supabase = SupabaseService();
  return await supabase.getPracticeQuestions(
    type: params['type'],
    level: params['level'],
  );
});

// User progress provider
final userProgressProvider = FutureProvider.family<Map<String, dynamic>?, Map<String, String>>((ref, params) async {
  final supabase = SupabaseService();
  return await supabase.getUserProgress(
    userId: params['userId']!,
    vocabularyId: params['vocabularyId']!,
  );
});

// User favorites provider
final userFavoritesProvider = FutureProvider.family<List<String>, String>((ref, userId) async {
  final supabase = SupabaseService();
  return await supabase.getUserFavorites(userId);
});

// Daily streak provider
final dailyStreakProvider = FutureProvider.family<Map<String, dynamic>?, String>((ref, userId) async {
  final supabase = SupabaseService();
  return await supabase.getDailyStreak(userId);
});
