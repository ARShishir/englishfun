// ignore_for_file: use_super_parameters, prefer_const_constructors, avoid_print, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:englishfun/navigation/app_router.dart';
import 'package:englishfun/core/widgets/custom_widgets.dart';
import 'package:englishfun/core/theme/app_theme.dart';
import 'package:englishfun/core/constants/app_constants.dart';
import 'package:englishfun/services/auth_provider.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  String? _selectedAnswer;
  bool _answered = false;

  @override
  Widget build(BuildContext context) {
    final questions = ref.watch(practiceQuestionsProvider({'difficulty_level': 'Advanced'}));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRouter.home),
        ),
      ),
      body: questions.when(
        data: (questionList) {
          if (questionList.isEmpty) {
            return Center(child: Text('No quiz questions available'));
          }

          final currentQuestion = questionList[_currentQuestionIndex];
          final progress = (_currentQuestionIndex + 1) / questionList.length;

          return _buildQuizContent(context, currentQuestion, progress, questionList.length);
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, st) {
          print('Error: $err');
          return Center(child: Text('Error loading quiz questions'));
        },
      ),
    );
  }

  Widget _buildQuizContent(BuildContext context, currentQuestion, double progress, int totalQuestions) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_currentQuestionIndex + 1}/$totalQuestions',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                'Score: $_score',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation(AppColors.primary),
          ),
          const SizedBox(height: 32),

          // Question
          CustomCard(
            backgroundColor: Color(0xFFF5F7FA),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentQuestion['question_text'] ?? 'Question',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 20),
                _buildQuestionOptions(currentQuestion),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Submit Button
          ElevatedButton.icon(
            onPressed: _answered
                ? () {
                    if (_currentQuestionIndex < totalQuestions - 1) {
                      setState(() {
                        _currentQuestionIndex++;
                        _selectedAnswer = null;
                        _answered = false;
                      });
                    } else {
                      _showQuizCompletion();
                    }
                  }
                : () {
                    setState(() => _answered = true);
                    final isCorrect = _selectedAnswer == currentQuestion['correct_answer'];
                    if (isCorrect) {
                      setState(() => _score++);
                    }
                  },
            icon: Icon(_answered ? Icons.arrow_forward : Icons.check),
            label: Text(_answered
                ? (_currentQuestionIndex == 9 ? 'Finish' : 'Next')
                : 'Submit Answer'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionOptions(currentQuestion) {
    final options = currentQuestion['options'] as List<dynamic>? ?? [];
    final correctAnswer = currentQuestion['correct_answer'] ?? '';

    return Column(
      children: options.asMap().entries.map((entry) {
        final option = entry.value;
        final isSelected = _selectedAnswer == option;
        final isCorrect = option == correctAnswer;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: _answered
                ? null
                : () => setState(() => _selectedAnswer = option),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? (_answered && isCorrect
                        ? Colors.green[100]
                        : _answered && !isCorrect
                            ? Colors.red[100]
                            : AppColors.primary.withOpacity(0.1))
                    : (_answered && isCorrect
                        ? Colors.green[100]
                        : Colors.grey[100]),
                border: Border.all(
                  color: isSelected
                      ? (_answered && isCorrect
                          ? Colors.green
                          : _answered && !isCorrect
                              ? Colors.red
                              : AppColors.primary)
                      : (_answered && isCorrect
                          ? Colors.green
                          : Colors.grey[300]!),
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? AppColors.primary : Colors.grey,
                      ),
                      color: isSelected ? AppColors.primary : Colors.transparent,
                    ),
                    child: isSelected
                        ? Icon(Icons.check, color: Colors.white, size: 16)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      option.toString(),
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (_answered && isCorrect)
                    Icon(Icons.check_circle, color: Colors.green),
                  if (_answered && isSelected && !isCorrect)
                    Icon(Icons.cancel, color: Colors.red),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showQuizCompletion() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quiz Complete! 🎉'),
        content: Text(
          'Your Score: $_score/10\n\n${(_score / 10 * 100).toStringAsFixed(0)}%',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go(AppRouter.home);
            },
            child: const Text('Back to Home'),
          ),
        ],
      ),
    );
  }
}
