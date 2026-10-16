import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_strings.dart';
import '../core/utils/responsive.dart';
import '../models/enums.dart';
import '../providers/quiz_provider.dart';
import '../widgets/app_background.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final quizProvider = context.watch<QuizProvider>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Kategori & Level'),
      ),
      body: AppBackground(
        child: SafeArea(
          child: ResponsiveCenter(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Halo, ${quizProvider.playerName}! 👋',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  'Pilih kategori kuis dan tingkat kesulitan:',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    children: [
                      Text(
                        'Kategori Video Game',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      ...QuizCategory.values.map((cat) {
                        final isSelected =
                            quizProvider.selectedCategory == cat;
                        final catColor = cat.color;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: InkWell(
                            onTap: () => quizProvider.selectCategory(cat),
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? catColor.withValues(alpha: isDark ? 0.3 : 0.15)
                                    : theme.cardColor,
                                border: Border.all(
                                  color: isSelected
                                      ? catColor
                                      : theme.dividerColor,
                                  width: isSelected ? 2.5 : 1.0,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: catColor.withValues(alpha: 0.25),
                                          blurRadius: 8,
                                          spreadRadius: 1,
                                        )
                                      ]
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 22,
                                    backgroundColor: isSelected
                                        ? catColor
                                        : catColor.withValues(alpha: 0.15),
                                    foregroundColor: isSelected
                                        ? Colors.white
                                        : catColor,
                                    child: Icon(cat.icon, size: 22),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cat.label,
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                            color: isSelected
                                                ? (isDark
                                                    ? catColor.withValues(alpha: 0.95)
                                                    : catColor)
                                                : theme.colorScheme.onSurface,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          cat.description,
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                            color: theme.colorScheme.onSurface
                                                .withValues(alpha: 0.75),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isSelected)
                                    Icon(
                                      Icons.check_circle_rounded,
                                      color: catColor,
                                      size: 24,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 16),
                      Text(
                        'Tingkat Kesulitan',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: Difficulty.values.map((diff) {
                          final isSelected =
                              quizProvider.selectedDifficulty == diff;
                          return Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: ChoiceChip(
                                label: Text(
                                    '${diff.label}\n(${diff.timerSeconds}s)'),
                                selected: isSelected,
                                selectedColor:
                                    diff.color.withValues(alpha: 0.25),
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? diff.color
                                      : theme.colorScheme.onSurface,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                                onSelected: (_) =>
                                    quizProvider.selectDifficulty(diff),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () async {
                    await quizProvider.startQuiz();
                    if (context.mounted) {
                      Navigator.of(context).pushNamed(AppStrings.routeQuiz);
                    }
                  },
                  icon: const Icon(Icons.rocket_launch_rounded),
                  label: const Text('MULAI KUIS NOW'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
