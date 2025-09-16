import 'package:flutter/material.dart';

/// Interface to be implemented in order
/// to load and save the selected `ClientConfig`.
abstract class UiConfigManager {
  /// Loads the selected color palette key as a `String`.
  String? loadAlternativeColorPaletteKey();

  /// Allows the consumer to save the selected color palette key as a `String`.
  Future<bool> saveAlternativeColorPaletteKey(String? value);

  /// Loads the selected `ThemeMode` as a `String`.
  ThemeMode? loadThemeMode();

  /// Allows the consumer to save the selected `ThemeMode`.
  Future<bool> saveThemeMode(ThemeMode value);

  /// Loads the selected high contrast setting
  bool loadIsHighContrastEnabled();

  /// Allows the consumer to save the selected high contrast setting.
  Future<bool> saveIsHighContrastEnabled(bool value);
}
