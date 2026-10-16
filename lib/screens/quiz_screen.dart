import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_strings.dart';
import '../core/utils/responsive.dart';
import '../models/enums.dart';
import '../providers/quiz_provider.dart';
import '../widgets/app_background.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  Future<bool> _showExitDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar dari Kuis?'),
        content: const Text('Progres kuis saat ini akan hilang.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('BATAL'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('KELUAR'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final quizProvider = context.watch<QuizProvider>();
    final currentQ = quizProvider.currentQuestion;

    if (quizProvider.status == QuizStatus.completed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed(AppStrings.routeResult);
      });
    }

    if (currentQ == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final category = quizProvider.selectedCategory;
    final categoryColor = category.color;
    final isLastQuestion =
        quizProvider.currentIndex == quizProvider.totalQuestions - 1;
    final selectedAnswerIndex = quizProvider.currentAnswer;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _showExitDialog(context);
        if (shouldPop && context.mounted) {
          quizProvider.resetQuiz();
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            'Soal ${quizProvider.currentIndex + 1}/${quizProvider.totalQuestions}',
          ),
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () async {
              final shouldPop = await _showExitDialog(context);
              if (shouldPop && context.mounted) {
                quizProvider.resetQuiz();
                Navigator.of(context).pop();
              }
            },
          ),
        ),
        body: AppBackground(
          child: SafeArea(
            child: ResponsiveCenter(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Progress + Category Chip dengan Warna Kategori Khusus + Timer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: categoryColor.withValues(alpha: isDark ? 0.25 : 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: categoryColor, width: 1.5),
                        ),
                        child: Row(
                          children: [
                            Icon(category.icon, size: 18, color: categoryColor),
                            const SizedBox(width: 6),
                            Text(
                              category.label,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? categoryColor.withValues(alpha: 0.9)
                                    : categoryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: quizProvider.remainingSeconds <= 5
                              ? Colors.red.withValues(alpha: 0.2)
                              : theme.colorScheme.primary
                                  .withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: quizProvider.remainingSeconds <= 5
                                ? Colors.red
                                : theme.colorScheme.primary,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.timer_rounded,
                              size: 18,
                              color: quizProvider.remainingSeconds <= 5
                                  ? Colors.red
                                  : theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${quizProvider.remainingSeconds}s',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: quizProvider.remainingSeconds <= 5
                                    ? Colors.red
                                    : theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: (quizProvider.currentIndex + 1) /
                        quizProvider.totalQuestions,
                    borderRadius: BorderRadius.circular(8),
                    color: categoryColor,
                    backgroundColor: categoryColor.withValues(alpha: 0.2),
                  ),
                  const SizedBox(height: 20),

                  // Question Card
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Card(
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                currentQ.text,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  height: 1.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Answer options A, B, C, D dengan kontras tinggi
                          ...List.generate(currentQ.options.length, (index) {
                            final isSelected = selectedAnswerIndex == index;
                            final optionText = currentQ.options[index];

                            // Warna kontras tinggi untuk Opsi A, B, C, D
                            final primaryCol = theme.colorScheme.primary;

                            final tileBg = isSelected
                                ? primaryCol.withValues(alpha: isDark ? 0.3 : 0.18)
                                : theme.cardColor;

                            final borderCol = isSelected
                                ? primaryCol
                                : theme.dividerColor;

                            // Badge A, B, C, D
                            final badgeBg = isSelected
                                ? primaryCol
                                : (isDark
                                    ? primaryCol.withValues(alpha: 0.25)
                                    : primaryCol.withValues(alpha: 0.12));

                            final badgeTextColor = isSelected
                                ? (isDark ? Colors.black : Colors.white)
                                : primaryCol;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: InkWell(
                                onTap: () {
                                  quizProvider.selectAnswer(index);
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: tileBg,
                                    border: Border.all(
                                      color: borderCol,
                                      width: isSelected ? 2.5 : 1.2,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: primaryCol.withValues(alpha: 0.3),
                                              blurRadius: 8,
                                              spreadRadius: 1,
                                            )
                                          ]
                                        : null,
                                  ),
                                  child: Row(
                                    children: [
                                      // Badge A, B, C, D
                                      Container(
                                        width: 32,
                                        height: 32,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: badgeBg,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: isSelected
                                                ? primaryCol
                                                : primaryCol.withValues(alpha: 0.4),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Text(
                                          String.fromCharCode(65 + index),
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: badgeTextColor,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      // Teks Opsi Jawaban dengan kontras tinggi
                                      Expanded(
                                        child: Text(
                                          optionText,
                                          style: theme.textTheme.bodyLarge?.copyWith(
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            color: theme.colorScheme.onSurface,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: selectedAnswerIndex == null
                        ? null
                        : () {
                            quizProvider.nextQuestion();
                          },
                    icon: Icon(
                      isLastQuestion
                          ? Icons.check_circle_rounded
                          : Icons.arrow_forward_rounded,
                    ),
                    label: Text(isLastQuestion ? 'SELESAI' : 'LANJUT'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
