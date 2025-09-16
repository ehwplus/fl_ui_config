import 'package:flutter/material.dart';

extension BuildContextWithThemeMode on BuildContext {
  bool get isLight {
    return Theme.of(this).brightness == Brightness.light;
  }

  bool get isDark {
    return Theme.of(this).brightness == Brightness.dark;
  }
}
