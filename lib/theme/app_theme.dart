import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    brightness: Brightness.light,

    colorScheme: const ColorScheme.light(
      primary: Color(0xFF6C5CE7),

      secondary: Color(0xFFFF7675),

      background: Color(0xFFF7F7F7),

      surface: Colors.white,

      onPrimary: Colors.white,

      onSurface: Colors.black,
    ),
  );

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,

    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF9B8CFF),

      secondary: Color(0xFFFF7675),

      background: Color(0xFF121212),

      surface: Color(0xFF1E1E1E),

      onPrimary: Colors.black,

      onSurface: Colors.white,
    ),
  );
}
