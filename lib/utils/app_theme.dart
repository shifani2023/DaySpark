import 'package:flutter/material.dart';

class AppTheme {
  // Main app colours
  static const Color primary = Color(0xFF7561F5);
  static const Color secondary = Color(0xFFFFA726);
  static const Color teal = Color(0xFF35BFA0);

  // Background and surface colours
  static const Color background = Color(0xFFFFF9F5);
  static const Color surface = Colors.white;

  // Text colours
  static const Color darkText = Color(0xFF28243D);
  static const Color secondaryText = Color(0xFF77738A);

  // Status colours
  static const Color success = Color(0xFF35BFA0);
  static const Color warning = Color(0xFFFFA726);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
      primary: primary,
      secondary: secondary,
      surface: surface,
    ),

    scaffoldBackgroundColor: background,

    appBarTheme: const AppBarTheme(
      backgroundColor: background,
      foregroundColor: darkText,
      elevation: 0,
      centerTitle: false,
    ),

    cardTheme: CardThemeData(
      color: surface,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: darkText,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: darkText,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        color: darkText,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        color: darkText,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: darkText,
      ),
      bodyMedium: TextStyle(
        color: secondaryText,
      ),
    ),

    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: Color(0xFFE9E4FF),
      labelTextStyle: WidgetStatePropertyAll(
        TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    ),
  );
}