import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/utils/responsive.dart';
import '../providers/quiz_provider.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final quizProvider = context.watch<QuizProvider>();
    final questions = quizProvider.questions;
    final answers = quizProvider.userAnswers;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Jawaban'),
      ),
      body: SafeArea(
        child: ResponsiveCenter(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              final q = questions[index];
              final userAnswerIndex =
                  index < answers.length ? answers[index] : null;
              final isCorrect = userAnswerIndex == q.correctIndex;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: isCorrect
                                ? Colors.green
                                : (userAnswerIndex == null
                                    ? Colors.grey
                                    : Colors.red),
                            child: Icon(
                              isCorrect
                                  ? Icons.check
                                  : (userAnswerIndex == null
                                      ? Icons.remove
                                      : Icons.close),
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Soal ${index + 1}',
                            style: theme.textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        q.text,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Column(
                        children: List.generate(q.options.length, (optIdx) {
                          final isUserChoice = userAnswerIndex == optIdx;
                          final isRightChoice = q.correctIndex == optIdx;

                          Color? tileBg;
                          Color? borderCol;

                          if (isRightChoice) {
                            tileBg = Colors.green.withValues(alpha: 0.15);
                            borderCol = Colors.green;
                          } else if (isUserChoice && !isCorrect) {
                            tileBg = Colors.red.withValues(alpha: 0.15);
                            borderCol = Colors.red;
                          }

                          return Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: tileBg ?? theme.cardColor,
                              border: Border.all(
                                color: borderCol ?? theme.dividerColor,
                                width: borderCol != null ? 1.5 : 0.5,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '${String.fromCharCode(65 + optIdx)}. ',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  child: Text(q.options[optIdx]),
                                ),
                                if (isRightChoice)
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 18,
                                  )
                                else if (isUserChoice)
                                  const Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                    size: 18,
                                  ),
                              ],
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: theme.dividerColor),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.lightbulb_rounded,
                              color: theme.colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Penjelasan: ${q.explanation}',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
