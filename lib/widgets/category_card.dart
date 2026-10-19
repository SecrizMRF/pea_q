import 'package:flutter/material.dart';
import '../models/enums.dart';

class CategoryCard extends StatelessWidget {
  final QuizCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final catColor = category.color;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? catColor.withValues(alpha: isDark ? 0.3 : 0.15)
                : theme.cardColor,
            border: Border.all(
              color: isSelected ? catColor : theme.dividerColor,
              width: isSelected ? 2.5 : 1.0,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: catColor.withValues(alpha: 0.25),
                      blurRadius: 8,
                      spreadRadius: 1,
                    )
                  ]
                : null,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: isSelected
                    ? catColor
                    : catColor.withValues(alpha: 0.15),
                foregroundColor: isSelected ? Colors.white : catColor,
                child: Icon(category.icon, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.label,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: isSelected
                            ? (isDark
                                ? catColor.withValues(alpha: 0.95)
                                : catColor)
                            : theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      category.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle_rounded,
                  color: catColor,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
