// ignore_for_file: use_super_parameters, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:englishfun/data/mock_data.dart';
import 'package:go_router/go_router.dart';
import 'package:englishfun/navigation/app_router.dart';
import 'package:englishfun/core/widgets/custom_widgets.dart';
import 'package:englishfun/core/theme/app_theme.dart';
import 'package:englishfun/core/constants/app_constants.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  String? _selectedAnswer;
  bool _answered = false;

  @override
  Widget build(BuildContext context) {
    final questions = MockData.practiceQuestions;
    final currentQuestion = questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / questions.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRouter.home),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Progress Bar and Score
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_currentQuestionIndex + 1}/${questions.length}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusMedium),
                  ),
                  child: Text(
                    'Score: $_score',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ProgressBar(
              progress: progress,
              progressColor: AppColors.primary,
            ),
            const SizedBox(height: 32),

            // Question
            CustomCard(
              backgroundColor: Color(0xFFF5F7FA),
              child: Text(
                currentQuestion.question,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 24),

            // Options
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: currentQuestion.options.map((option) {
                final isSelected = _selectedAnswer == option;
                final isCorrect = option == currentQuestion.correctAnswer;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: _answered ? null : () {
                      setState(() {
                        _selectedAnswer = option;
                        _answered = true;
                        if (isCorrect) {
                          _score++;
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: _answered
                            ? (isCorrect
                                ? Colors.green[50]
                                : (isSelected ? Colors.red[50] : Colors.white))
                            : (isSelected
                                ? AppColors.primary.withValues(alpha: 0.1)
                                : Colors.white),
                        border: Border.all(
                          color: _answered
                              ? (isCorrect ? Colors.green : Colors.red)
                              : (isSelected ? AppColors.primary : AppColors.divider),
                          width: isSelected || (_answered && isCorrect) 
                              ? 2 
                              : 1,
                        ),
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusSmall),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              option,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                          if (_answered && isCorrect)
                            const Icon(Icons.check_circle,
                                color: Colors.green)
                          else if (_answered && isSelected && !isCorrect)
                            const Icon(Icons.cancel, color: Colors.red),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Next Button
            if (_answered)
              RoundedButton(
                label: _currentQuestionIndex < questions.length - 1
                    ? 'Next Question'
                    : 'See Results',
                onPressed: () {
                  if (_currentQuestionIndex < questions.length - 1) {
                    setState(() {
                      _currentQuestionIndex++;
                      _selectedAnswer = null;
                      _answered = false;
                    });
                  } else {
                    _showResultsDialog();
                  }
                },
              )
            else
              RoundedButton(
                label: 'Select an answer',
                backgroundColor: Colors.grey,
                onPressed: null,
              ),
          ],
        ),
      ),
    );
  }

  void _showResultsDialog() {
    final questions = MockData.practiceQuestions;
    final percentage = ((_score / questions.length) * 100).toStringAsFixed(1);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quiz Completed! 🎉'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Score: $_score/${questions.length}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$percentage%',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // close dialog
              context.go(AppRouter.home); // navigate to home via router
            },
            child: const Text('Back'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _currentQuestionIndex = 0;
                _score = 0;
                _selectedAnswer = null;
                _answered = false;
              });
              Navigator.of(context).pop();
            },
            child: const Text('Retake Quiz'),
          ),
        ],
      ),
    );
  }
}
