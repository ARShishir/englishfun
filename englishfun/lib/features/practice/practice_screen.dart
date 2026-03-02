// ignore_for_file: use_super_parameters, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:englishfun/data/mock_data.dart';
import 'package:go_router/go_router.dart';
import 'package:englishfun/navigation/app_router.dart';
import 'package:englishfun/core/widgets/custom_widgets.dart';
import 'package:englishfun/core/theme/app_theme.dart';
import 'package:englishfun/core/constants/app_constants.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({Key? key}) : super(key: key);

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  int _currentQuestionIndex = 0;
  List<String> selectedAnswers = [];
  bool _showFeedback = false;
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();
    selectedAnswers = List.filled(MockData.practiceQuestions.length, '');
  }

  @override
  Widget build(BuildContext context) {
    final question = MockData.practiceQuestions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / MockData.practiceQuestions.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Practice'),
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
            // Progress
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_currentQuestionIndex + 1}/${MockData.practiceQuestions.length}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '⏱️ 02:45',
                  style: Theme.of(context).textTheme.titleMedium,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question.question,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  if (question.type.name == 'sentenceArrangement')
                    _buildSentenceArrangement(question)
                  else if (question.type.name == 'fillBlank')
                    _buildFillBlank(question)
                  else
                    _buildSpellingTest(question),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Feedback
            if (_showFeedback)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _isCorrect ? Colors.green[50] : Colors.red[50],
                  border: Border.all(
                    color: _isCorrect ? Colors.green : Colors.red,
                  ),
                  borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isCorrect ? '✅ Correct!' : '❌ Incorrect',
                      style: TextStyle(
                        color: _isCorrect ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      question.explanation,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            // Next Button
            RoundedButton(
              label: _currentQuestionIndex < MockData.practiceQuestions.length - 1
                  ? 'Next'
                  : 'Complete',
              onPressed: () {
                if (!_showFeedback) {
                  setState(() {
                    _showFeedback = true;
                    _isCorrect = selectedAnswers[_currentQuestionIndex]
                        .contains(question.correctAnswer);
                  });
                } else {
                  if (_currentQuestionIndex <
                      MockData.practiceQuestions.length - 1) {
                    setState(() {
                      _currentQuestionIndex++;
                      _showFeedback = false;
                    });
                  } else {
                    _showCompletionDialog();
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSentenceArrangement(dynamic question) {
    return Column(
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: question.options.map<Widget>((option) {
            final isSelected = selectedAnswers[_currentQuestionIndex]
                .contains(option);
            return WordChip(
              label: option,
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedAnswers[_currentQuestionIndex] =
                        selectedAnswers[_currentQuestionIndex]
                            .replaceAll('$option ', '');
                  } else {
                    selectedAnswers[_currentQuestionIndex] +=
                        '${selectedAnswers[_currentQuestionIndex].isEmpty ? '' : ' '}$option';
                  }
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.divider),
            borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
          ),
          child: Text(
            selectedAnswers[_currentQuestionIndex].isNotEmpty
                ? selectedAnswers[_currentQuestionIndex]
                : 'Your answer will appear here',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildFillBlank(dynamic question) {
    return Column(
      children: question.options.map<Widget>((option) {
        final isSelected = selectedAnswers[_currentQuestionIndex] == option;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: WordChip(
            label: option,
            isSelected: isSelected,
            onTap: () {
              setState(() {
                selectedAnswers[_currentQuestionIndex] = option;
              });
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSpellingTest(dynamic question) {
    return Column(
      children: question.options.map<Widget>((option) {
        final isSelected = selectedAnswers[_currentQuestionIndex] == option;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: WordChip(
            label: option,
            isSelected: isSelected,
            onTap: () {
              setState(() {
                selectedAnswers[_currentQuestionIndex] = option;
              });
            },
          ),
        );
      }).toList(),
    );
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Great Job! 🎉'),
        content: const Text('You have completed today\'s practice!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // close dialog
              context.go(AppRouter.home); // navigate to home
            },
            child: const Text('Back to Home'),
          ),
        ],
      ),
    );
  }
}
