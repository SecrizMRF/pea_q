import 'package:flutter/material.dart';
import '../models/enums.dart';

class PowerUpCard extends StatelessWidget {
  final PowerUp selectedPowerUp;
  final VoidCallback onTap;

  const PowerUpCard({
    super.key,
    required this.selectedPowerUp,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final powerColor = selectedPowerUp.color;

    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.all(14.0),
          decoration: BoxDecoration(
            color: selectedPowerUp == PowerUp.none
                ? theme.cardColor
                : powerColor.withValues(alpha: isDark ? 0.20 : 0.10),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selectedPowerUp == PowerUp.none
                  ? theme.dividerColor
                  : powerColor,
              width: selectedPowerUp == PowerUp.none ? 1.0 : 2.0,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: selectedPowerUp == PowerUp.none
                      ? theme.colorScheme.primary.withValues(alpha: 0.1)
                      : powerColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  selectedPowerUp.icon,
                  size: 22,
                  color: selectedPowerUp == PowerUp.none
                      ? theme.colorScheme.primary
                      : Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          selectedPowerUp.label,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: selectedPowerUp == PowerUp.none
                                ? theme.colorScheme.onSurface
                                : (isDark ? powerColor.withValues(alpha: 0.95) : powerColor),
                          ),
                        ),
                        const SizedBox(width: 6),
                        if (selectedPowerUp != PowerUp.none)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: powerColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'AKTIF ⚡',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: powerColor,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      selectedPowerUp.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.70),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.sync_rounded,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
