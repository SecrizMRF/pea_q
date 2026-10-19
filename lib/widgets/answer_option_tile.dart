import 'package:flutter/material.dart';

class AnswerOptionTile extends StatelessWidget {
  final int index;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const AnswerOptionTile({
    super.key,
    required this.index,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryCol = theme.colorScheme.primary;

    final tileBg = isSelected
        ? primaryCol.withValues(alpha: isDark ? 0.3 : 0.18)
        : theme.cardColor;

    final borderCol = isSelected ? primaryCol : theme.dividerColor;

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
        onTap: onTap,
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
              Expanded(
                child: Text(
                  text,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
