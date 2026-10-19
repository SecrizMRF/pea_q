import 'package:flutter/material.dart';

class QuizProgressBar extends StatelessWidget {
  final int currentIndex;
  final int totalQuestions;
  final Color color;

  const QuizProgressBar({
    super.key,
    required this.currentIndex,
    required this.totalQuestions,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (totalQuestions == 0) return const SizedBox.shrink();

    return LinearProgressIndicator(
      value: (currentIndex + 1) / totalQuestions,
      borderRadius: BorderRadius.circular(8),
      color: color,
      backgroundColor: color.withValues(alpha: 0.2),
    );
  }
}
