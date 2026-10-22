import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_strings.dart';
import '../core/utils/responsive.dart';
import '../models/enums.dart';
import '../providers/quiz_provider.dart';
import '../widgets/answer_option_tile.dart';
import '../widgets/app_background.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/primary_button.dart';
import '../widgets/question_card.dart';
import '../widgets/quiz_progress_bar.dart';
import '../widgets/timer_badge.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  Future<bool> _showExitDialog(BuildContext context) {
    return ConfirmDialog.show(
      context,
      title: 'Keluar dari Kuis?',
      content: 'Progres kuis saat ini akan hilang.',
      confirmText: 'KELUAR',
      confirmColor: Colors.red,
    );
  }

  Widget _buildPowerUpActivationButton(
      BuildContext context, QuizProvider quizProvider) {
    final powerUp = quizProvider.selectedPowerUp;
    final isUsed = quizProvider.isPowerUpUsed;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (isUsed) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outlined, size: 16, color: Colors.grey),
            const SizedBox(width: 6),
            Text(
              'Power Up (${powerUp.label}) Telah Digunakan',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return InkWell(
      onTap: () {
        quizProvider.activatePowerUp();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              powerUp == PowerUp.extraTime
                  ? '⚡ Extra Time Aktif! Waktu bertambah +5 detik'
                  : '🗡️ Question Slayer Aktif! Soal dijawab benar & dilewati',
            ),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: powerUp.color.withValues(alpha: isDark ? 0.3 : 0.18),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: powerUp.color, width: 1.8),
          boxShadow: [
            BoxShadow(
              color: powerUp.color.withValues(alpha: 0.25),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(powerUp.icon, size: 18, color: powerUp.color),
            const SizedBox(width: 8),
            Text(
              'AKTIFKAN POWER UP: ${powerUp.label.toUpperCase()}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: powerUp.color,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.bolt_rounded, size: 16, color: Colors.amber),
          ],
        ),
      ),
    );
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
            'Soal ${quizProvider.currentIndex + 1} dari ${quizProvider.totalQuestions}',
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top Row: Category Badge & Timer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: categoryColor
                              .withValues(alpha: isDark ? 0.25 : 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: categoryColor, width: 1.5),
                        ),
                        child: Row(
                          children: [
                            Icon(category.icon, size: 16, color: categoryColor),
                            const SizedBox(width: 6),
                            Text(
                              category.label,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: isDark
                                    ? categoryColor.withValues(alpha: 0.95)
                                    : categoryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TimerBadge(
                        remainingSeconds: quizProvider.remainingSeconds,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Progress Bar dengan Indikator Soal
                  QuizProgressBar(
                    currentIndex: quizProvider.currentIndex,
                    totalQuestions: quizProvider.totalQuestions,
                    color: categoryColor,
                  ),
                  const SizedBox(height: 14),

                  // Fitur Aktivasi Power Up (Jika Dipilih)
                  if (quizProvider.selectedPowerUp != PowerUp.none) ...[
                    _buildPowerUpActivationButton(context, quizProvider),
                    const SizedBox(height: 12),
                  ],

                  // Soal & Opsi Jawaban
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          QuestionCard(text: currentQ.text),
                          const SizedBox(height: 16),
                          Text(
                            'Pilih Salah Satu Jawaban:',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.75),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...List.generate(currentQ.options.length, (index) {
                            return AnswerOptionTile(
                              index: index,
                              text: currentQ.options[index],
                              isSelected: selectedAnswerIndex == index,
                              onTap: () => quizProvider.selectAnswer(index),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  PrimaryButton(
                    onPressed: selectedAnswerIndex == null
                        ? null
                        : () => quizProvider.nextQuestion(),
                    icon: isLastQuestion
                        ? Icons.check_circle_rounded
                        : Icons.arrow_forward_rounded,
                    label: isLastQuestion ? 'SELESAI' : 'LANJUTKAN',
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
