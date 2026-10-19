import 'package:flutter/material.dart';

class QuestionCard extends StatelessWidget {
  final String text;

  const QuestionCard({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          text,
          style: theme.textTheme.titleMedium?.copyWith(
            height: 1.5,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
