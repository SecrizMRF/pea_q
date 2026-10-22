import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // Font Modern Minimalis Professional (Plus Jakarta Sans)
  static TextStyle header({
    required Color color,
    double fontSize = 20,
    FontWeight fontWeight = FontWeight.bold,
  }) {
    return GoogleFonts.plusJakartaSans(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: 1.3,
    );
  }

  static TextStyle title({
    required Color color,
    double fontSize = 18,
    FontWeight fontWeight = FontWeight.w700,
  }) {
    return GoogleFonts.plusJakartaSans(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: 1.3,
    );
  }

  static TextStyle body({
    required Color color,
    double fontSize = 15,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return GoogleFonts.plusJakartaSans(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: 1.4,
    );
  }

  static TextStyle caption({
    required Color color,
    double fontSize = 12,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    return GoogleFonts.plusJakartaSans(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }
}
