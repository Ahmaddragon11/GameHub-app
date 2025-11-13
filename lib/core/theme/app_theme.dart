import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    notifyListeners();
  }
}

class AppTheme {
  static const Color _primaryColor = Color(0xFF6200EE);
  static const Color _secondaryColor = Color(0xFF03DAC6);

  static final TextTheme _appTextTheme = TextTheme(
    displayLarge: GoogleFonts.orbitron(
      fontSize: 57,
      fontWeight: FontWeight.bold,
      color: _primaryColor,
    ),
    titleLarge: GoogleFonts.orbitron(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    bodyMedium: GoogleFonts.openSans(fontSize: 14, color: Colors.white70),
    labelLarge: GoogleFonts.orbitron(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  );

  static final ElevatedButtonThemeData _elevatedButtonTheme =
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _secondaryColor,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.orbitron(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  static final CardThemeData _cardTheme = CardThemeData(
    elevation: 12,
    shadowColor: _primaryColor.withAlpha(128),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24.0),
      side: BorderSide(color: _secondaryColor.withAlpha(178), width: 1),
    ),
    clipBehavior: Clip.antiAlias,
    color: Colors.grey[900]?.withAlpha(204),
  );

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: _primaryColor,
      scaffoldBackgroundColor: const Color(0xFF121212),
      colorScheme: const ColorScheme.dark(
        primary: _primaryColor,
        secondary: _secondaryColor,
        surface: Color(0xFF1E1E1E),
      ),
      textTheme: _appTextTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        titleTextStyle: GoogleFonts.orbitron(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      elevatedButtonTheme: _elevatedButtonTheme,
      cardTheme: _cardTheme,
      iconTheme: const IconThemeData(color: _secondaryColor),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: _primaryColor,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: const ColorScheme.light(
        primary: _primaryColor,
        secondary: _secondaryColor,
        surface: Colors.white,
      ),
      textTheme: _appTextTheme.apply(
        bodyColor: Colors.black,
        displayColor: _primaryColor,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        titleTextStyle: GoogleFonts.orbitron(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      elevatedButtonTheme: _elevatedButtonTheme,
      cardTheme: _cardTheme.copyWith(
        color: Colors.white,
        shadowColor: _primaryColor.withAlpha(64),
      ),
      iconTheme: const IconThemeData(color: _primaryColor),
    );
  }
}
