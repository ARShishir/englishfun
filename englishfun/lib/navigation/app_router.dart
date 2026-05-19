// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:englishfun/features/splash/splash_screen.dart';
import 'package:englishfun/features/onboarding/onboarding_screen.dart';
import 'package:englishfun/features/auth/login_screen.dart';
import 'package:englishfun/features/auth/signup_screen.dart';
import 'package:englishfun/features/home/home_screen.dart';
import 'package:englishfun/features/practice/practice_screen.dart';
import 'package:englishfun/features/vocabulary/vocabulary_list_screen.dart';
import 'package:englishfun/features/vocabulary/vocabulary_detail_screen.dart';
import 'package:englishfun/features/flashcard/flashcard_screen.dart';
import 'package:englishfun/features/quiz/quiz_screen.dart';
import 'package:englishfun/features/profile/profile_screen.dart';
import 'package:englishfun/navigation/main_shell.dart';

class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String practice = '/practice';
  static const String vocabulary = '/vocabulary';
  static const String vocabularyDetail = '/vocabulary/:id';
  static const String flashcard = '/flashcard';
  static const String quiz = '/quiz';
  static const String profile = '/profile';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: signup,
        builder: (context, state) => const SignupScreen(),
      ),

      // Shell that holds the bottom navigation
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child, currentLocation: state.uri.toString()),
        routes: [
          GoRoute(
            path: home,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: practice,
            builder: (context, state) => const PracticeScreen(),
          ),
          GoRoute(
            path: vocabulary,
            builder: (context, state) => const VocabularyListScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id = state.pathParameters['id'];
                  return VocabularyDetailScreen(vocabularyId: id ?? '1');
                },
              ),
            ],
          ),
          GoRoute(
            path: profile,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      // Other standalone routes
      GoRoute(
        path: flashcard,
        builder: (context, state) => const FlashcardScreen(),
      ),
      GoRoute(
        path: quiz,
        builder: (context, state) => const QuizScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Route not found: ${state.uri}'),
      ),
    ),
  );
}
