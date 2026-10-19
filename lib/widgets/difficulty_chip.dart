import 'package:flutter/material.dart';
import '../models/enums.dart';

class DifficultyChip extends StatelessWidget {
  final Difficulty difficulty;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const DifficultyChip({
    super.key,
    required this.difficulty,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ChoiceChip(
      label: Text('${difficulty.label}\n(${difficulty.timerSeconds}s)'),
      selected: isSelected,
      selectedColor: difficulty.color.withValues(alpha: 0.25),
      labelStyle: TextStyle(
        color: isSelected ? difficulty.color : theme.colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      onSelected: onSelected,
    );
  }
}
