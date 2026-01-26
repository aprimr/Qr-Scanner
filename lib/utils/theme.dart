import 'package:flutter/material.dart';

class AppTheme {
  static const Color _primaryColor = Color(0xFFFFFFFF);
  static const Color _secondaryColor = Color(0xFF000000);
  static const Color _accentColor = Color(0xFF32CD32);

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      surface: _primaryColor,
      inverseSurface: _secondaryColor,
      primary: _accentColor,
      onPrimary: _primaryColor,
      outline: Color(0xFF495F7E),
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      surface: _secondaryColor,
      inverseSurface: _primaryColor,
      primary: _accentColor,
      onPrimary: _secondaryColor,
      outline: Color(0xFF97A1AD),
    ),
  );
}
