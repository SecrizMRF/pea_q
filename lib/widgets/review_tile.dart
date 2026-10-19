import 'package:flutter/material.dart';
import '../models/question.dart';

class ReviewTile extends StatelessWidget {
  final int index;
  final Question question;
  final int? userAnswerIndex;

  const ReviewTile({
    super.key,
    required this.index,
    required this.question,
    required this.userAnswerIndex,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isCorrect = userAnswerIndex == question.correctIndex;

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
                      : (userAnswerIndex == null ? Colors.grey : Colors.red),
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
              question.text,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: List.generate(question.options.length, (optIdx) {
                final isUserChoice = userAnswerIndex == optIdx;
                final isRightChoice = question.correctIndex == optIdx;

                Color tileBg = theme.cardColor;
                Color borderCol = theme.dividerColor;

                if (isRightChoice) {
                  tileBg = Colors.green.withValues(alpha: isDark ? 0.25 : 0.15);
                  borderCol = Colors.green;
                } else if (isUserChoice && !isCorrect) {
                  tileBg = Colors.red.withValues(alpha: isDark ? 0.25 : 0.15);
                  borderCol = Colors.red;
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: tileBg,
                    border: Border.all(
                      color: borderCol,
                      width: (isRightChoice || isUserChoice) ? 1.8 : 0.8,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${String.fromCharCode(65 + optIdx)}. ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isRightChoice
                              ? Colors.green
                              : (isUserChoice && !isCorrect
                                  ? Colors.red
                                  : theme.colorScheme.onSurface),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          question.options[optIdx],
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: (isRightChoice || isUserChoice)
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
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
                      'Penjelasan: ${question.explanation}',
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
  }
}
