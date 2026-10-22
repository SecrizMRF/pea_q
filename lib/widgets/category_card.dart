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
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark
                    ? catColor.withValues(alpha: 0.22)
                    : catColor.withValues(alpha: 0.10))
                : theme.cardColor,
            border: Border.all(
              color: isSelected ? catColor : theme.dividerColor,
              width: isSelected ? 2.5 : 1.2,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? catColor.withValues(alpha: 0.25)
                    : Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                blurRadius: isSelected ? 12 : 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Pill Badge Soal Tersedia
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: catColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: catColor.withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.quiz_rounded,
                      size: 13,
                      color: catColor,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '15 Soal Tersedia',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: catColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Logo / Ikon Kategori Besar di Tengah
              Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? catColor
                      : catColor.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: catColor.withValues(alpha: 0.35),
                            blurRadius: 10,
                            spreadRadius: 1,
                          )
                        ]
                      : null,
                ),
                child: Icon(
                  category.icon,
                  size: 32,
                  color: isSelected ? Colors.white : catColor,
                ),
              ),
              const SizedBox(height: 10),

              // Judul Kategori di Tengah
              Text(
                category.label,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? (isDark
                          ? catColor.withValues(alpha: 0.95)
                          : catColor)
                      : theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),

              // Deskripsi Kategori di Tengah
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Text(
                  category.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                    fontSize: 12,
                    height: 1.25,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
