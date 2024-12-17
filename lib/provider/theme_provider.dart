import 'package:flutter/material.dart';


ThemeData lightTheme = ThemeData.light().copyWith(
  colorScheme: const ColorScheme.light().copyWith(
      primary: Colors.blueGrey[500],
      onPrimary: Colors.blueGrey[50],
      onSurface: Colors.black
  ),
  scaffoldBackgroundColor: Colors.blueGrey[100],
  iconTheme: const IconThemeData(
    color: Colors.black,
  ),

  floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.blueGrey[400],
      foregroundColor: Colors.black45
  ),
);

ThemeData darkTheme = ThemeData.dark().copyWith(
  colorScheme: const ColorScheme.dark().copyWith(
      primary: Colors.blueGrey[500],
      onPrimary: Colors.blueGrey[50],
      onSurface: Colors.white
  ),
  scaffoldBackgroundColor: Colors.black45,
  iconTheme: const IconThemeData(
    color: Colors.white,
  ),
  floatingActionButtonTheme:  FloatingActionButtonThemeData(
      backgroundColor: Colors.blueGrey[800],
      foregroundColor: Colors.white70
  ),
);

class ThemeProvider extends ChangeNotifier {
  ThemeData _theme = lightTheme;

  ThemeData get theme => _theme;

  void toggleTheme() {
    final isDark = _theme == darkTheme;
    if (isDark) {
      _theme = lightTheme;
    } else {
      _theme = darkTheme;
    }
    notifyListeners();
  }
}