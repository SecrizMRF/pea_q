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
                            Icon(category.icon, size: 18, color: categoryColor),
                            const SizedBox(width: 6),
                            Text(
                              category.label,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
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
                  const SizedBox(height: 12),
                  QuizProgressBar(
                    currentIndex: quizProvider.currentIndex,
                    totalQuestions: quizProvider.totalQuestions,
                    color: categoryColor,
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          QuestionCard(text: currentQ.text),
                          const SizedBox(height: 20),
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
                    label: isLastQuestion ? 'SELESAI' : 'LANJUT',
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
