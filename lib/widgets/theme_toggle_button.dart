import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;

    return IconButton(
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return RotationTransition(
            turns: animation,
            child: ScaleTransition(scale: animation, child: child),
          );
        },
        child: Icon(
          isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
          key: ValueKey<bool>(isDark),
        ),
      ),
      tooltip: isDark ? 'Beralih ke Mode Terang' : 'Beralih ke Mode Gelap',
      onPressed: () {
        themeProvider.toggleTheme(!isDark);
      },
    );
  }
}
