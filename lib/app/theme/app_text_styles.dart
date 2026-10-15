import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // Retro / Pixel Title & Header font (Press Start 2P)
  static TextStyle pixelHeader({
    required Color color,
    double fontSize = 20,
  }) {
    return GoogleFonts.pressStart2p(
      color: color,
      fontSize: fontSize,
      height: 1.4,
    );
  }

  // Body font (Nunito)
  static TextStyle body({
    required Color color,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return GoogleFonts.nunito(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }

  static TextStyle title({
    required Color color,
    double fontSize = 18,
    FontWeight fontWeight = FontWeight.bold,
  }) {
    return GoogleFonts.nunito(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }

  static TextStyle caption({
    required Color color,
    double fontSize = 12,
  }) {
    return GoogleFonts.nunito(
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
    );
  }
}
