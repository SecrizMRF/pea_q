import 'package:flutter/material.dart';
import '../core/utils/formatters.dart';

class ScoreSummaryCard extends StatelessWidget {
  final int score;
  final int correctCount;
  final int totalQuestions;

  const ScoreSummaryCard({
    super.key,
    required this.score,
    required this.correctCount,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              'Skor Akhir',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              AppFormatters.formatScore(score),
              style: theme.textTheme.displayLarge?.copyWith(
                fontSize: 40,
                color: theme.colorScheme.primary,
              ),
            ),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text('Benar', style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 4),
                    Text(
                      '$correctCount / $totalQuestions',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('Akurasi', style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 4),
                    Text(
                      AppFormatters.formatPercentage(correctCount, totalQuestions),
                      style: theme.textTheme.titleLarge,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
