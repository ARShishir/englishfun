// ignore_for_file: use_super_parameters, prefer_const_constructors, use_key_in_widget_constructors, deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:englishfun/navigation/app_router.dart';
import 'package:englishfun/core/widgets/custom_widgets.dart';
import 'package:englishfun/core/theme/app_theme.dart';
import 'package:englishfun/core/constants/app_constants.dart';
import 'package:englishfun/services/auth_provider.dart';

class PracticeScreen extends ConsumerStatefulWidget {
  const PracticeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends ConsumerState<PracticeScreen> {
  int _currentQuestionIndex = 0;
  List<String> selectedAnswers = [];
  bool _showFeedback = false;
  bool _isCorrect = false;

  @override
  Widget build(BuildContext context) {
    final questions = ref.watch(practiceQuestionsProvider({}));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Practice'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRouter.home),
        ),
      ),
      body: questions.when(
        data: (questionList) {
          if (questionList.isEmpty) {
            return Center(child: Text('No practice questions available'));
          }

          selectedAnswers = List.filled(questionList.length, selectedAnswers.elementAtOrNull(_currentQuestionIndex) ?? '');

          final question = questionList[_currentQuestionIndex];
          final progress = (_currentQuestionIndex + 1) / questionList.length;

          return _buildPracticeContent(context, question, progress, questionList.length);
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, st) {
          print('Error: $err');
          return Center(child: Text('Error loading practice questions'));
        },
      ),
    );
  }

  Widget _buildPracticeContent(BuildContext context, question, double progress, int totalQuestions) {
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
                  question['question_text'] ?? 'Question',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 20),
                _buildMultipleChoice(question),
              ],
            ),
          ),
          const SizedBox(height: 32),

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
              child: Text(
                _isCorrect ? '✓ Correct!' : '✗ Incorrect. Try again!',
                style: TextStyle(
                  color: _isCorrect ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          const SizedBox(height: 24),

          Row(
            children: [
              if (_currentQuestionIndex > 0)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _previousQuestion,
                    icon: Icon(Icons.arrow_back),
                    label: Text('Previous'),
                  ),
                ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _nextQuestion,
                  icon: Icon(_currentQuestionIndex == 0 ? Icons.arrow_forward : Icons.check),
                  label: Text(_currentQuestionIndex == 0 ? 'Next' : 'Submit'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMultipleChoice(question) {
    final options = question['options'] as List<dynamic>? ?? [];
    final correctAnswer = question['correct_answer'] ?? '';

    return Column(
      children: options.asMap().entries.map((entry) {
        final option = entry.value;
        final isSelected = selectedAnswers[_currentQuestionIndex] == option;
        final isCorrect = option == correctAnswer;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedAnswers[_currentQuestionIndex] = option;
                _isCorrect = option == correctAnswer;
                _showFeedback = true;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _showFeedback && isCorrect
                    ? Colors.green[100]
                    : _showFeedback && isSelected && !isCorrect
                        ? Colors.red[100]
                        : isSelected
                            ? AppColors.primary.withOpacity(0.1)
                            : Colors.grey[100],
                border: Border.all(
                  color: _showFeedback && isCorrect
                      ? Colors.green
                      : _showFeedback && isSelected && !isCorrect
                          ? Colors.red
                          : isSelected
                              ? AppColors.primary
                              : Colors.grey[300]!,
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
                  if (_showFeedback && isCorrect)
                    Icon(Icons.check_circle, color: Colors.green),
                  if (_showFeedback && isSelected && !isCorrect)
                    Icon(Icons.cancel, color: Colors.red),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _previousQuestion() {
    setState(() {
      _showFeedback = false;
      _isCorrect = false;
      _currentQuestionIndex--;
    });
  }

  void _nextQuestion() {
    setState(() {
      _showFeedback = false;
      _isCorrect = false;
      _currentQuestionIndex++;
    });
  }
}

class ProgressBar extends StatelessWidget {
  final double progress;
  final Color progressColor;

  const ProgressBar({
    required this.progress,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
      child: LinearProgressIndicator(
        value: progress,
        minHeight: 8,
        backgroundColor: Colors.grey[300],
        valueColor: AlwaysStoppedAnimation(progressColor),
      ),
    );
  }
}
