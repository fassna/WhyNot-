import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Neo-brutalist Light Palette
  static const Color background = Color(0xFFFAF8F5);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color yellowAccent = Color(0xFFFFE500);
  static const Color pinkAccent = Color(0xFFFF758F);
  static const Color cyanAccent = Color(0xFF4CC9F0);
  static const Color greenAccent = Color(0xFF38B000);
  static const Color orangeAccent = Color(0xFFFF9F1C);
  static const Color purpleAccent = Color(0xFFB5179E);
  static const Color darkText = Color(0xFF1E1E24);
  static const Color borderColor = Color(0xFF1E1E24);

  static const double borderWidth = 3.0;
  static const double borderRadius = 16.0;

  static BoxDecoration neoBoxDecoration({
    Color color = cardBg,
    Color borderColor = borderColor,
    double borderRadius = borderRadius,
    double shadowOffset = 4.0,
    Color shadowColor = borderColor,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: borderColor, width: borderWidth),
      boxShadow: [
        BoxShadow(
          color: shadowColor,
          offset: Offset(shadowOffset, shadowOffset),
          blurRadius: 0,
        ),
      ],
    );
  }

  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.fredokaTextTheme();
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      primaryColor: yellowAccent,
      colorScheme: const ColorScheme.light(
        primary: yellowAccent,
        secondary: pinkAccent,
        surface: cardBg,
        onSurface: darkText,
      ),
      textTheme: baseTextTheme.copyWith(
        displayLarge: GoogleFonts.fredoka(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: darkText,
        ),
        displayMedium: GoogleFonts.fredoka(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: darkText,
        ),
        titleLarge: GoogleFonts.fredoka(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: darkText,
        ),
        titleMedium: GoogleFonts.fredoka(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: darkText,
        ),
        bodyLarge: GoogleFonts.fredoka(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: darkText,
        ),
        bodyMedium: GoogleFonts.fredoka(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: darkText,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: yellowAccent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.fredoka(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: darkText,
        ),
        iconTheme: const IconThemeData(color: darkText, size: 28),
      ),
    );
  }
}
