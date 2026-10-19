import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_strings.dart';
import '../core/utils/responsive.dart';
import '../models/enums.dart';
import '../providers/quiz_provider.dart';
import '../widgets/app_background.dart';
import '../widgets/category_card.dart';
import '../widgets/difficulty_chip.dart';
import '../widgets/primary_button.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                        return CategoryCard(
                          category: cat,
                          isSelected: quizProvider.selectedCategory == cat,
                          onTap: () => quizProvider.selectCategory(cat),
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
                              child: DifficultyChip(
                                difficulty: diff,
                                isSelected: isSelected,
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
                PrimaryButton(
                  onPressed: () async {
                    await quizProvider.startQuiz();
                    if (context.mounted) {
                      Navigator.of(context).pushNamed(AppStrings.routeQuiz);
                    }
                  },
                  icon: Icons.rocket_launch_rounded,
                  label: 'MULAI KUIS NOW',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
