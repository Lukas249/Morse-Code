import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData.light().copyWith(
    colorScheme: const ColorScheme.light().copyWith(
        primary: Colors.lightBlue,
        onPrimary: Colors.white,
    ),
    iconTheme: const IconThemeData(
      color: Colors.black
    )
);

ThemeData darkTheme = ThemeData.dark().copyWith(
    colorScheme: const ColorScheme.dark().copyWith(
        primary: Colors.lightBlue,
        onPrimary: Colors.white,
    ),
    iconTheme: const IconThemeData(
      color: Colors.white
    )
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