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
    final isDark = theme.brightness == Brightness.dark;
    final wrongCount = totalQuestions - correctCount;

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Circular Score Ring
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 110,
                  height: 110,
                  child: CircularProgressIndicator(
                    value: totalQuestions > 0 ? (correctCount / totalQuestions) : 0,
                    strokeWidth: 10,
                    backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
                    color: theme.colorScheme.primary,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppFormatters.formatScore(score),
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Text(
                      'Skor',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 11,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(height: 1),
            const SizedBox(height: 16),

            // Stat Grid (Benar, Salah, Akurasi)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn(
                  context,
                  label: 'Jawaban Benar',
                  value: '$correctCount / $totalQuestions',
                  valueColor: Colors.green,
                  icon: Icons.check_circle_rounded,
                ),
                Container(
                  height: 36,
                  width: 1,
                  color: theme.dividerColor,
                ),
                _buildStatColumn(
                  context,
                  label: 'Jawaban Salah',
                  value: '$wrongCount',
                  valueColor: Colors.red,
                  icon: Icons.cancel_rounded,
                ),
                Container(
                  height: 36,
                  width: 1,
                  color: theme.dividerColor,
                ),
                _buildStatColumn(
                  context,
                  label: 'Akurasi',
                  value: AppFormatters.formatPercentage(correctCount, totalQuestions),
                  valueColor: isDark ? theme.colorScheme.primary : theme.colorScheme.primary,
                  icon: Icons.pie_chart_rounded,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(
    BuildContext context, {
    required String label,
    required String value,
    required Color valueColor,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, size: 20, color: valueColor),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: valueColor,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 11,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
          ),
        ),
      ],
    );
  }
}
