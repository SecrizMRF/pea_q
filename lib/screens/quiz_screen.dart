import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_strings.dart';
import '../core/utils/responsive.dart';
import '../models/enums.dart';
import '../providers/quiz_provider.dart';

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
    final quizProvider = context.watch<QuizProvider>();
    final currentQ = quizProvider.currentQuestion;

    if (quizProvider.status == QuizStatus.completed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed(AppStrings.routeResult);
      });
    }

    if (currentQ == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
        body: SafeArea(
          child: ResponsiveCenter(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Progress + Timer
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Chip(
                      avatar: Icon(quizProvider.selectedCategory.icon, size: 18),
                      label: Text(quizProvider.selectedCategory.label),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: quizProvider.remainingSeconds <= 5
                            ? Colors.red.withValues(alpha: 0.2)
                            : theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: quizProvider.remainingSeconds <= 5
                              ? Colors.red
                              : theme.colorScheme.primary,
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
                ),
                const SizedBox(height: 24),

                // Question Card
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              currentQ.text,
                              style: theme.textTheme.titleMedium?.copyWith(
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Answer options
                        ...List.generate(currentQ.options.length, (index) {
                          final isSelected = selectedAnswerIndex == index;
                          final optionText = currentQ.options[index];

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
                                  color: isSelected
                                      ? theme.colorScheme.primary
                                          .withValues(alpha: 0.15)
                                      : theme.cardColor,
                                  border: Border.all(
                                    color: isSelected
                                        ? theme.colorScheme.primary
                                        : theme.dividerColor,
                                    width: isSelected ? 2 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 14,
                                      backgroundColor: isSelected
                                          ? theme.colorScheme.primary
                                          : theme.dividerColor,
                                      child: Text(
                                        String.fromCharCode(65 + index),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isSelected
                                              ? Colors.white
                                              : theme.colorScheme.onSurface,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Text(
                                        optionText,
                                        style: theme.textTheme.bodyLarge,
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
    );
  }
}
