import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeProvider() {
    _loadTheme();
  }

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    notifyListeners();
    _saveTheme();
  }

  void _saveTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isDarkTheme", _themeMode == ThemeMode.dark ? true : false);
  }

  void _loadTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _themeMode = prefs.getBool('isDarkTheme') == true
        ? ThemeMode.dark
        : ThemeMode.light;
    notifyListeners();
  }
}
