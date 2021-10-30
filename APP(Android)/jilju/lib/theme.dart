import 'package:flutter/material.dart';

import 'setting.dart';

enum JiljuTheme { light, dark }

extension JiljuThemeExtension on JiljuTheme {
  ThemeData get theme {
    switch (this) {
      case JiljuTheme.light:
        return ThemeData.light();
      case JiljuTheme.dark:
        return ThemeData.dark();
    }
  }

  String get name {
    switch (this) {
      case JiljuTheme.light:
        return 'light';
      case JiljuTheme.dark:
        return 'dark';
    }
  }

  Color get splashScreenBackgroundColor {
    switch (this) {
      case JiljuTheme.light:
        return Colors.white;
      case JiljuTheme.dark:
        return Colors.black;
    }
  }
}

class ThemeChangeNotifier extends ChangeNotifier {
  JiljuTheme _theme;

  JiljuTheme get theme => _theme;

  set theme(JiljuTheme jiljuTheme) {
    _setTheme(jiljuTheme);
  }

  ThemeChangeNotifier() : _theme = JiljuTheme.light {
    _getTheme();
  }

  Future<void> _setTheme(JiljuTheme jiljuTheme) async {
    await setTheme(_theme = jiljuTheme);
    notifyListeners();
  }

  Future<void> _getTheme() async {
    _theme = await getTheme();
    notifyListeners();
  }
}
