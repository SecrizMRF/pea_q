import 'package:flutter/material.dart';

class TimerBadge extends StatelessWidget {
  final int remainingSeconds;

  const TimerBadge({
    super.key,
    required this.remainingSeconds,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCritical = remainingSeconds <= 5;
    final activeColor = isCritical ? Colors.red : theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isCritical
            ? Colors.red.withValues(alpha: 0.2)
            : theme.colorScheme.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: activeColor,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer_rounded,
            size: 18,
            color: activeColor,
          ),
          const SizedBox(width: 6),
          Text(
            '${remainingSeconds}s',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: activeColor,
            ),
          ),
        ],
      ),
    );
  }
}
