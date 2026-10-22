import 'package:flutter/material.dart';
import '../core/constants/app_assets.dart';

class PeaQookLogo extends StatelessWidget {
  final double size;
  final bool showShadow;

  const PeaQookLogo({
    super.key,
    this.size = 120,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.35),
                  blurRadius: size * 0.15,
                  spreadRadius: size * 0.03,
                ),
              ]
            : null,
      ),
      child: ClipOval(
        child: Image.asset(
          AppAssets.appLogo,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: primaryColor,
              alignment: Alignment.center,
              child: const Icon(
                Icons.sports_esports_rounded,
                color: Colors.white,
                size: 40,
              ),
            );
          },
        ),
      ),
    );
  }
}
