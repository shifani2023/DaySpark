import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF7762D8);
  static const Color secondary = Color(0xFFFFB74D);
  static const Color teal = Color(0xFF26A69A);
  static const Color darkText = Color(0xFF30264D);
  static const Color secondaryText = Color(0xFF6E6885);
  static const Color background = Color(0xFFF8F6FF);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: secondary,
        surface: background,
      ),
      scaffoldBackgroundColor: background,
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: darkText,
        elevation: 0,
        centerTitle: false,
      ),
    );
  }
}