import 'package:flutter/material.dart';

class AppTheme {
  // Core Colors
  static const Color primaryColor = Color(0xFF4A90E2);
  static const Color accentColor = Color(0xFF50E3C2);
  static const Color errorColor = Color(0xFFD0021B);
  static const Color darkBackgroundColor = Color(0xFF121212);
  static const Color lightBackgroundColor = Color(0xFFF5F5F5);

  // Game Specific Colors
  static final Map<String, Color> gameColors = {
    'snake': Colors.green.shade600,
    'flappyBird': Colors.orange.shade600,
    'ticTacToe': Colors.purple.shade600,
  };

  // --- Themes ---
  static ThemeData lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: lightBackgroundColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        error: errorColor,
        surface: lightBackgroundColor,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 1,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      iconTheme: const IconThemeData(
        color: primaryColor,
      ),
      textTheme: _lightTextTheme,
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: darkBackgroundColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: accentColor,
        error: errorColor,
        surface: darkBackgroundColor,
      ),
      appBarTheme: AppBarTheme(
        elevation: 1,
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        titleTextStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      cardTheme: CardThemeData(
        elevation: 6,
        color: Colors.grey[850],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      iconTheme: const IconThemeData(
        color: accentColor,
      ),
      textTheme: _darkTextTheme,
    );
  }

  // --- Text Styles ---
  static const TextTheme _lightTextTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
    titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.black87),
    bodyLarge: TextStyle(fontSize: 16, color: Colors.black54),
    bodyMedium: TextStyle(fontSize: 14, color: Colors.black54),
    labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
  );

  static const TextTheme _darkTextTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
    titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white),
    bodyLarge: TextStyle(fontSize: 16, color: Colors.white70),
    bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
    labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
  );

  // --- Design Constants ---
  static const double borderRadius = 16.0;
  static const double spacing = 8.0;
  static const double elevation = 8.0;
}
