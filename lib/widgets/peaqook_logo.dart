import 'dart:math' as math;
import 'package:flutter/material.dart';

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
    final secondaryColor = theme.colorScheme.secondary;
    final accentColor = theme.colorScheme.tertiary;

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
      child: CustomPaint(
        size: Size(size, size),
        painter: PeaQookLogoPainter(
          primaryColor: primaryColor,
          secondaryColor: secondaryColor,
          accentColor: accentColor,
        ),
      ),
    );
  }
}

class PeaQookLogoPainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;

  PeaQookLogoPainter({
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.52, size.height * 0.46);
    final r = size.width * 0.40;

    // 1. Outer Badge Path - Round Circle with Swooping Pointed Tail ("Q" Badge Shape)
    final badgePath = Path();

    // Start at top center of circle
    badgePath.moveTo(center.dx, center.dy - r);

    // Right semicircle down to bottom-right
    badgePath.arcTo(
      Rect.fromCircle(center: center, radius: r),
      -math.pi / 2,
      math.pi * 1.35, // down to around 5 o'clock (243 deg)
      false,
    );

    // Swoop down-left to sharp pointed tail tip (bentuk 'Q' tail)
    final tailTip = Offset(size.width * 0.06, size.height * 0.94);
    badgePath.quadraticBezierTo(
      center.dx - r * 0.7,
      center.dy + r * 1.1,
      tailTip.dx,
      tailTip.dy,
    );

    // Curve back up-right to left side of circle
    badgePath.quadraticBezierTo(
      center.dx - r * 0.8,
      center.dy + r * 0.3,
      center.dx - r,
      center.dy,
    );

    // Complete top-left arc
    badgePath.arcTo(
      Rect.fromCircle(center: center, radius: r),
      math.pi,
      math.pi / 2,
      false,
    );
    badgePath.close();

    // Paint Outer Badge Fill
    final badgeGradient = RadialGradient(
      center: Alignment(-0.2, -0.3),
      radius: 0.9,
      colors: [
        primaryColor,
        Color.lerp(primaryColor, Colors.black, 0.7)!,
      ],
    );

    final badgePaint = Paint()
      ..shader = badgeGradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    canvas.drawPath(badgePath, badgePaint);

    // Save layer for clipping grid inside badge
    canvas.save();
    canvas.clipPath(badgePath);

    // 2. Grid/Crosshair Lines inside Badge (Sesuai Referensi)
    final gridPaint = Paint()
      ..color = accentColor.withValues(alpha: 0.18)
      ..strokeWidth = size.width * 0.012
      ..style = PaintingStyle.stroke;

    final stepX = size.width * 0.22;
    for (double x = stepX; x < size.width; x += stepX) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        gridPaint,
      );
    }

    final stepY = size.height * 0.22;
    for (double y = stepY; y < size.height; y += stepY) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    // 3. Peacock Neck & Head Silhouette (Siluet Leher & Kepala Merak dari Referensi)
    final neckPath = Path();

    // Start near tail swoosh base
    final neckStart = Offset(size.width * 0.12, size.height * 0.82);
    neckPath.moveTo(neckStart.dx, neckStart.dy);

    // Outer Neck Curve up to the right
    neckPath.cubicTo(
      center.dx - r * 0.2,
      center.dy + r * 0.6,
      center.dx + r * 0.65,
      center.dy + r * 0.2,
      center.dx + r * 0.52,
      center.dy - r * 0.32,
    );

    // Top Head Curve sweeping left
    neckPath.cubicTo(
      center.dx + r * 0.42,
      center.dy - r * 0.62,
      center.dx + r * 0.05,
      center.dy - r * 0.58,
      center.dx - r * 0.15,
      center.dy - r * 0.42,
    );

    // Beak Point sloping down-left
    final beakTip = Offset(center.dx - r * 0.38, center.dy - r * 0.18);
    neckPath.lineTo(beakTip.dx, beakTip.dy);

    // Under-chin and Throat curve returning back
    neckPath.quadraticBezierTo(
      center.dx - r * 0.12,
      center.dy - r * 0.22,
      center.dx + r * 0.02,
      center.dy - r * 0.12,
    );

    // Inner Neck Curve going down-left towards base
    neckPath.cubicTo(
      center.dx + r * 0.28,
      center.dy + r * 0.10,
      center.dx - r * 0.05,
      center.dy + r * 0.45,
      neckStart.dx,
      neckStart.dy,
    );
    neckPath.close();

    // Draw Neck Silhouette in Crisp White / Bright Color
    final neckPaint = Paint()
      ..color = const Color(0xFFF9F5FF)
      ..style = PaintingStyle.fill;

    canvas.drawPath(neckPath, neckPaint);

    // 4. Teardrop/Almond Eye Hole Cutout
    final eyeCenter = Offset(center.dx - r * 0.08, center.dy - r * 0.34);
    final eyePath = Path();
    eyePath.moveTo(eyeCenter.dx - r * 0.08, eyeCenter.dy);
    eyePath.quadraticBezierTo(
      eyeCenter.dx,
      eyeCenter.dy - r * 0.08,
      eyeCenter.dx + r * 0.07,
      eyeCenter.dy,
    );
    eyePath.quadraticBezierTo(
      eyeCenter.dx,
      eyeCenter.dy + r * 0.06,
      eyeCenter.dx - r * 0.08,
      eyeCenter.dy,
    );
    eyePath.close();

    // Cut eye out using dark/primary fill
    final eyePaint = Paint()
      ..color = Color.lerp(primaryColor, Colors.black, 0.65)!
      ..style = PaintingStyle.fill;

    canvas.drawPath(eyePath, eyePaint);

    // 5. 3 Crown Feathers (Jambul Merak)
    final headTop = Offset(center.dx + r * 0.02, center.dy - r * 0.52);

    final crownAngles = [-2.15, -2.40, -2.65]; // angles in radians pointing up-left
    final crownLen = r * 0.32;

    for (final angle in crownAngles) {
      final endPt = Offset(
        headTop.dx + crownLen * math.cos(angle),
        headTop.dy + crownLen * math.sin(angle),
      );

      // Pin stem
      final stemPaint = Paint()
        ..color = accentColor
        ..strokeWidth = size.width * 0.022
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(headTop, endPt, stemPaint);

      // Pin head ball
      final ballPaint = Paint()
        ..color = secondaryColor
        ..style = PaintingStyle.fill;

      canvas.drawCircle(endPt, size.width * 0.032, ballPaint);

      // Inner dot accent
      final dotPaint = Paint()
        ..color = accentColor
        ..style = PaintingStyle.fill;

      canvas.drawCircle(endPt, size.width * 0.015, dotPaint);
    }

    canvas.restore(); // Restore layer

    // 6. Gold/Accent Outer Ring Stroke
    final borderPaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.03;

    canvas.drawPath(badgePath, borderPaint);
  }

  @override
  bool shouldRepaint(covariant PeaQookLogoPainter oldDelegate) {
    return oldDelegate.primaryColor != primaryColor ||
        oldDelegate.secondaryColor != secondaryColor ||
        oldDelegate.accentColor != accentColor;
  }
}
