import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_strings.dart';
import '../core/utils/formatters.dart';
import '../core/utils/responsive.dart';
import '../providers/leaderboard_provider.dart';
import '../providers/quiz_provider.dart';
import '../widgets/app_background.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _hasSaved = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasSaved) {
        _saveResult();
      }
    });
  }

  void _saveResult() {
    final quizProvider = context.read<QuizProvider>();
    final result = quizProvider.getResult();
    context.read<LeaderboardProvider>().addResult(result);
    setState(() {
      _hasSaved = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final quizProvider = context.watch<QuizProvider>();
    final category = quizProvider.selectedCategory;
    final categoryColor = category.color;
    final score = quizProvider.score;
    final correct = quizProvider.correctCount;
    final total = quizProvider.totalQuestions;

    String headline;
    IconData icon;
    Color iconColor;

    if (score >= 80) {
      headline = 'EXCELLENT! 🏆';
      icon = Icons.emoji_events_rounded;
      iconColor = Colors.amber;
    } else if (score >= 50) {
      headline = 'GOOD JOB! 👍';
      icon = Icons.thumb_up_alt_rounded;
      iconColor = theme.colorScheme.primary;
    } else {
      headline = 'KEEP TRYING! 💪';
      icon = Icons.sentiment_dissatisfied_rounded;
      iconColor = Colors.orange;
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Hasil Kuis'),
        automaticallyImplyLeading: false,
      ),
      body: AppBackground(
        child: SafeArea(
          child: ResponsiveCenter(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  icon,
                  size: 80,
                  color: iconColor,
                ),
                const SizedBox(height: 16),
                Text(
                  headline,
                  style: theme.textTheme.displayLarge?.copyWith(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Pemain: ${quizProvider.playerName}',
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Center(
                  child: Chip(
                    avatar: Icon(category.icon, size: 18, color: categoryColor),
                    label: Text(
                      category.label,
                      style: TextStyle(
                        color: isDark ? categoryColor.withValues(alpha: 0.95) : categoryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: categoryColor.withValues(alpha: isDark ? 0.25 : 0.15),
                    side: BorderSide(color: categoryColor),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
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
                                  '$correct / $total',
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
                                  AppFormatters.formatPercentage(correct, total),
                                  style: theme.textTheme.titleLarge,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppStrings.routeReview);
                  },
                  icon: const Icon(Icons.rate_review_rounded),
                  label: const Text('REVIEW JAWABAN'),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppStrings.routeLeaderboard);
                  },
                  icon: const Icon(Icons.leaderboard_rounded),
                  label: const Text('LIHAT LEADERBOARD'),
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: () {
                    quizProvider.resetQuiz();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppStrings.routeHome,
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.home_rounded),
                  label: const Text('KE MENU UTAMA'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
