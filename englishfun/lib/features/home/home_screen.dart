// ignore_for_file: prefer_const_constructors, use_super_parameters, unused_element

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:englishfun/data/mock_data.dart';
import 'package:englishfun/core/widgets/custom_widgets.dart';
import 'package:englishfun/core/theme/app_theme.dart';
import 'package:englishfun/core/constants/app_constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('English Fun'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: _buildHomeTab(context),
    );
  }

  Widget _buildHomeTab(BuildContext context) {
    final user = MockData.currentUser;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting Card
          CustomCard(
            backgroundColor: AppColors.primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${AppStrings.goodMorning}, ${user.name}! 👋',
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
                      label: AppStrings.streak,
                      value: '${user.dailyStreak}',
                      subValue: AppStrings.days,
                    ),
                    _StatBox(
                      icon: '⭐',
                      label: AppStrings.xp,
                      value: '${user.totalXP}',
                      subValue: 'points',
                    ),
                    _StatBox(
                      icon: '📈',
                      label: 'Progress',
                      value: '65%',
                      subValue: 'complete',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Quick Action Cards
          Text(
            'Continue Learning',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          _buildQuickActionCard(
            icon: '✏️',
            title: AppStrings.dailyPractice,
            subtitle: '2/5 completed',
            onTap: () => context.go('/practice'),
          ),
          const SizedBox(height: 12),
          _buildQuickActionCard(
            icon: '📚',
            title: AppStrings.vocabularyLesson,
            subtitle: 'Learn 10 new words',
            onTap: () => context.go('/vocabulary'),
          ),
          const SizedBox(height: 12),
          _buildQuickActionCard(
            icon: '🎴',
            title: AppStrings.flashcardMode,
            subtitle: 'Practice with flashcards',
            onTap: () => context.go('/flashcard'),
          ),
          const SizedBox(height: 12),
          _buildQuickActionCard(
            icon: '📊',
            title: AppStrings.weeklyProgress,
            subtitle: 'View your stats',
            onTap: () {},
          ),
          const SizedBox(height: 24),
          
          // Progress Bar
          Text(
            'Today\'s Goal',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          ProgressBar(
            progress: 0.65,
            label: 'Daily Goal Progress',
            progressColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
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
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF999999),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward, color: Color(0xFF999999)),
        ],
      ),
    );
  }

  Widget _buildOtherTabs() {
    return Center(
      child: Text('Tap an item from navigation'),
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
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          subValue,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
