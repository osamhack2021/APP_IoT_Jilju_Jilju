import 'package:flutter/material.dart';

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
}
