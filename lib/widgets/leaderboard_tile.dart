import 'package:flutter/material.dart';
import '../app/theme/app_text_styles.dart';
import '../core/utils/formatters.dart';
import '../models/quiz_result.dart';

class LeaderboardTile extends StatelessWidget {
  final int rank;
  final QuizResult result;

  const LeaderboardTile({
    super.key,
    required this.rank,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final catColor = result.category.color;

    Widget rankBadge;
    if (rank == 1) {
      rankBadge = const Text('🥇', style: TextStyle(fontSize: 24));
    } else if (rank == 2) {
      rankBadge = const Text('🥈', style: TextStyle(fontSize: 24));
    } else if (rank == 3) {
      rankBadge = const Text('🥉', style: TextStyle(fontSize: 24));
    } else {
      rankBadge = CircleAvatar(
        radius: 14,
        backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
        child: Text(
          '#$rank',
          style: TextStyle(
            fontSize: 12,
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: rankBadge,
        title: Row(
          children: [
            Expanded(
              child: Text(
                result.playerName,
                style: theme.textTheme.titleMedium,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: catColor.withValues(alpha: isDark ? 0.25 : 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: catColor, width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(result.category.icon, size: 12, color: catColor),
                  const SizedBox(width: 4),
                  Text(
                    result.category.label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isDark ? catColor.withValues(alpha: 0.95) : catColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            'Level: ${result.difficulty.label} • ${AppFormatters.formatDate(result.date)}',
            style: AppTextStyles.caption(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ),
        trailing: Text(
          AppFormatters.formatScore(result.score),
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
