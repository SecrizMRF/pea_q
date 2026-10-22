import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/utils/responsive.dart';
import '../providers/quiz_provider.dart';
import '../widgets/app_background.dart';
import '../widgets/review_tile.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final quizProvider = context.watch<QuizProvider>();
    final questions = quizProvider.questions;
    final answers = quizProvider.userAnswers;
    final correctCount = quizProvider.correctCount;
    final totalQuestions = quizProvider.totalQuestions;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Review Jawaban'),
      ),
      body: AppBackground(
        child: SafeArea(
          child: ResponsiveCenter(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Header Banner Summary
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.green.withValues(alpha: 0.15),
                          child: const Icon(
                            Icons.fact_check_rounded,
                            color: Colors.green,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Ringkasan: $correctCount dari $totalQuestions Soal Dijawab Benar',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      final q = questions[index];
                      final userAnswerIndex =
                          index < answers.length ? answers[index] : null;

                      return ReviewTile(
                        index: index,
                        question: q,
                        userAnswerIndex: userAnswerIndex,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
