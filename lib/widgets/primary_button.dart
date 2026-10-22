import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final bool isFullWidth;
  final bool isLoading;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final double? fontSize;
  final double? iconSize;

  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.isFullWidth = true,
    this.isLoading = false,
    this.backgroundColor,
    this.padding,
    this.fontSize,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget childWidget;
    if (isLoading) {
      childWidget = SizedBox(
        width: iconSize ?? 20,
        height: iconSize ?? 20,
        child: const CircularProgressIndicator(
          strokeWidth: 2.5,
          color: Colors.white,
        ),
      );
    } else if (icon != null) {
      childWidget = Row(
        mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: iconSize ?? 22),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize ?? 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      );
    } else {
      childWidget = Text(
        label,
        style: TextStyle(
          fontSize: fontSize ?? 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      );
    }

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ?? theme.colorScheme.primary,
      foregroundColor: Colors.white,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      elevation: 4,
      shadowColor: (backgroundColor ?? theme.colorScheme.primary).withValues(alpha: 0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );

    if (isFullWidth) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: childWidget,
        ),
      );
    }

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: buttonStyle,
      child: childWidget,
    );
  }
}
