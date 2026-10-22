import 'package:flutter/material.dart';

class AppColors {
  // Light Theme Colors (Dominan putih dengan aksen & gradasi ungu palette)
  static const Color lightText = Color(0xFF100420);
  static const Color lightBackground = Color(0xFFFAFAFE);
  static const Color lightPrimary = Color(0xFF401084);
  static const Color lightSecondary = Color(0xFFEEA372);
  static const Color lightAccent = Color(0xFFADBA17);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightCorrect = Color(0xFF2E9E5B);
  static const Color lightWrong = Color(0xFFE05252);
  static const Color lightBorder = Color(0xFFE2D5F3);

  // Dark Theme Colors
  static const Color darkText = Color(0xFFEBDEFB);
  static const Color darkBackground = Color(0xFF100420);
  static const Color darkPrimary = Color(0xFFAA79EF);
  static const Color darkSecondary = Color(0xFF8F4411);
  static const Color darkAccent = Color(0xFFDBE843);
  static const Color darkSurface = Color(0xFF1B0B33);
  static const Color darkCard = Color(0xFF23103D);
  static const Color darkCorrect = Color(0xFF4CC785);
  static const Color darkWrong = Color(0xFFFF7A7A);
  static const Color darkBorder = Color(0xFF4A2B73);

  // Background Gradients (Dominan putih dengan sedikit gradasi ungu)
  static const LinearGradient lightBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFFFFF), // Putih murni di bagian atas
      Color(0xFFFBF8FF), // Putih dengan nuansa lavender lembut
      Color(0xFFF2E8FB), // Gradasi ungu lembut dari color palette di bagian bawah
    ],
  );

  static const LinearGradient darkBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF180A2E), // Dark slate purple top
      Color(0xFF0E041A), // Midnight purple bottom
    ],
  );

  // Status & Medal Colors
  static const Color gold = Color(0xFFFFD700);
  static const Color silver = Color(0xFFC0C0C0);
  static const Color bronze = Color(0xFFCD7F32);
}
