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
    final isDark = theme.brightness == Brightness.dark;
    final diffColor = difficulty.color;

    return ChoiceChip(
      showCheckmark: false,
      avatar: CircleAvatar(
        radius: 6,
        backgroundColor: diffColor,
      ),
      label: Text(
        '${difficulty.label}\n${difficulty.timerSeconds} dtk',
        textAlign: TextAlign.center,
      ),
      selected: isSelected,
      selectedColor: diffColor.withValues(alpha: isDark ? 0.35 : 0.20),
      backgroundColor: theme.cardColor,
      side: BorderSide(
        color: isSelected ? diffColor : theme.dividerColor,
        width: isSelected ? 2.0 : 1.0,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      labelStyle: TextStyle(
        color: isSelected ? diffColor : theme.colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
        fontSize: 13,
      ),
      onSelected: onSelected,
    );
  }
}
