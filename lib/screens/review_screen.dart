import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/utils/responsive.dart';
import '../providers/quiz_provider.dart';
import '../widgets/app_background.dart';
import '../widgets/review_tile.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quizProvider = context.watch<QuizProvider>();
    final questions = quizProvider.questions;
    final answers = quizProvider.userAnswers;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Review Jawaban'),
      ),
      body: AppBackground(
        child: SafeArea(
          child: ResponsiveCenter(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final q = questions[index];
                final userAnswerIndex =
                    index < answers.length ? answers[index] : null;

                return ReviewTile(
                  index: index,
                  question: q,
                  userAnswerIndex: userAnswerIndex,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
