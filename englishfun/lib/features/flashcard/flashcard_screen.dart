// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:englishfun/data/mock_data.dart';
import 'package:go_router/go_router.dart';
import 'package:englishfun/navigation/app_router.dart';
import 'package:englishfun/core/widgets/custom_widgets.dart';
import 'package:englishfun/core/constants/app_constants.dart';

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({Key? key}) : super(key: key);

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int _currentIndex = 0;
  List<bool> _isFlipped = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _isFlipped = List.filled(MockData.vocabularyList.length, false);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcard Mode'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRouter.home),
        ),
      ),
      body: Column(
        children: [
          // Progress
          Padding(
            padding: const EdgeInsets.all(AppConstants.spacing16),
            child: ProgressBar(
              progress: (_currentIndex + 1) / MockData.vocabularyList.length,
              label:
                  'Card ${_currentIndex + 1} of ${MockData.vocabularyList.length}',
            ),
          ),

          // Flashcards
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemCount: MockData.vocabularyList.length,
              itemBuilder: (context, index) {
                final vocab = MockData.vocabularyList[index];
                return FlashcardWidget(
                  vocab: vocab,
                  isFlipped: _isFlipped[index],
                  onFlip: () {
                    setState(() {
                      _isFlipped[index] = !_isFlipped[index];
                    });
                  },
                );
              },
            ),
          ),

          // Navigation Buttons
          Padding(
            padding: const EdgeInsets.all(AppConstants.spacing16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RoundedButton(
                  label: 'Previous',
                  backgroundColor: Colors.grey,
                  onPressed: _currentIndex > 0
                      ? () {
                          _pageController.previousPage(
                            duration: AppConstants.mediumDuration,
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
                ),
                RoundedButton(
                  label: 'Next',
                  onPressed: _currentIndex < MockData.vocabularyList.length - 1
                      ? () {
                          _pageController.nextPage(
                            duration: AppConstants.mediumDuration,
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FlashcardWidget extends StatelessWidget {
  final dynamic vocab;
  final bool isFlipped;
  final VoidCallback onFlip;

  const FlashcardWidget({
    Key? key,
    required this.vocab,
    required this.isFlipped,
    required this.onFlip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacing24),
        child: GestureDetector(
          onTap: onFlip,
          child: AnimatedSwitcher(
            duration: AppConstants.mediumDuration,
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: CustomCard(
              key: ValueKey(isFlipped),
              backgroundColor: isFlipped
                  ? const Color(0xFFFBC02D)
                  : const Color(0xFF0D47A1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isFlipped) ...[
                    const Text('Tap to reveal', style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    )),
                    const SizedBox(height: 24),
                    Text(
                      vocab.word,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ] else ...[
                    Text(
                      vocab.meaning,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '(${vocab.bangla})',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusSmall),
                      ),
                      child: Text(
                        'Synonyms: ${vocab.synonyms.join(', ')}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                  const Text('Tap to flip', style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
