// ignore_for_file: prefer_const_constructors, use_super_parameters, unused_element, avoid_print

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:englishfun/core/widgets/custom_widgets.dart';
import 'package:englishfun/core/theme/app_theme.dart';
import 'package:englishfun/core/constants/app_constants.dart';
import 'package:englishfun/services/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('English Fun'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await ref.read(authControllerProvider.notifier).signOut();
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
      body: userProfile.when(
        data: (user) {
          if (user == null) {
            return Center(child: Text('User not found'));
          }
          return _buildHomeContent(context, user);
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) {
          print('Error: $err');
          return Center(child: Text('Error loading profile'));
        },
      ),
    );
  }

  Widget _buildHomeContent(BuildContext context, user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomCard(
            backgroundColor: AppColors.primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, ${user.name}! 👋',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _StatBox(
                      icon: '🔥',
                      label: 'Streak',
                      value: '${user.dailyStreak}',
                      subValue: 'days',
                    ),
                    _StatBox(
                      icon: '⭐',
                      label: 'XP',
                      value: '${user.totalXP}',
                      subValue: 'points',
                    ),
                    _StatBox(
                      icon: '📚',
                      label: 'Words',
                      value: '${user.totalWordsLearned}',
                      subValue: 'learned',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Continue Learning',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          _buildActionCard(
            context: context,
            icon: '✏️',
            title: 'Daily Practice',
            subtitle: 'Learn and practice',
            onTap: () => context.go('/practice'),
          ),
          const SizedBox(height: 12),
          _buildActionCard(
            context: context,
            icon: '📚',
            title: 'Vocabulary',
            subtitle: 'Browse word list',
            onTap: () => context.go('/vocabulary'),
          ),
          const SizedBox(height: 12),
          _buildActionCard(
            context: context,
            icon: '🎴',
            title: 'Flashcards',
            subtitle: 'Practice with cards',
            onTap: () => context.go('/flashcard'),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return CustomCard(
      onTap: onTap,
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 40)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(subtitle, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final String subValue;

  const _StatBox({
    required this.icon,
    required this.label,
    required this.value,
    required this.subValue,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
          Text(subValue, style: const TextStyle(fontSize: 12, color: Colors.white70)),
        ],
      ),
    );
  }
}
