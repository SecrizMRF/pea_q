import 'package:flutter/material.dart';
import '../app/theme/app_colors.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  final Color? difficultyColor;

  const AppBackground({
    super.key,
    required this.child,
    this.difficultyColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseGradient = isDark
        ? AppColors.darkBackgroundGradient
        : AppColors.lightBackgroundGradient;

    List<Color> colors = List.from(baseGradient.colors);

    if (difficultyColor != null) {
      final tintAlpha = isDark ? 0.30 : 0.20;
      final tintColor = difficultyColor!.withValues(alpha: tintAlpha);

      colors = colors.map((col) => Color.alphaBlend(tintColor, col)).toList();
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: baseGradient.begin,
          end: baseGradient.end,
          colors: colors,
        ),
      ),
      child: child,
    );
  }
}
