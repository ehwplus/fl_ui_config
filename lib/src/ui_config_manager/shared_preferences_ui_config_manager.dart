import 'package:fl_ui_config/src/ui_config_manager/ui_config_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUiConfigManager extends UiConfigManager {
  SharedPreferencesUiConfigManager({required this.sharedPreferences});

  static const _packageName = 'fl_ui_config';

  static const _keyThemeMode = '$_packageName.KEY_THEME_MODE';
  static const _keyAlternativeColorPalette = '$_packageName.KEY_ALTERNATIVE_COLOR_PALETTE';
  static const _keyIsHighContrastEnabled = '$_packageName.KEY_IS_HIGH_CONTRAST_ENABLED';

  static const ThemeMode _defaultUiMode = ThemeMode.system;
  static const bool _defaultIsHighContrastEnabled = false;

  final SharedPreferences sharedPreferences;

  ThemeMode? _themeMode;

  String? _alternativeColorPaletteKey;

  @override
  ThemeMode loadThemeMode() {
    final key = sharedPreferences.getString(_keyThemeMode) ?? _defaultUiMode;
    return _themeMode ?? ThemeMode.values.firstWhere((value) => value.name == key, orElse: () => ThemeMode.system);
  }

  @override
  String? loadAlternativeColorPaletteKey() {
    final alternativeColorPaletteKey = sharedPreferences.getString(_keyAlternativeColorPalette);
    return _alternativeColorPaletteKey ?? alternativeColorPaletteKey;
  }

  @override
  bool loadIsHighContrastEnabled() {
    bool isHighContrastEnabled = sharedPreferences.getBool(_keyIsHighContrastEnabled) ?? _defaultIsHighContrastEnabled;
    return isHighContrastEnabled;
  }

  @override
  Future<bool> saveThemeMode(ThemeMode value) async {
    _themeMode = value;
    final result = await sharedPreferences.setString(_keyThemeMode, value.name);
    return result;
  }

  @override
  Future<bool> saveAlternativeColorPaletteKey(String? value) async {
    _alternativeColorPaletteKey = value;
    if (value == null) {
      return sharedPreferences.remove(_keyAlternativeColorPalette);
    }
    final result = await sharedPreferences.setString(_keyAlternativeColorPalette, value);
    return result;
  }

  @override
  Future<bool> saveIsHighContrastEnabled(bool value) async {
    final result = await sharedPreferences.setBool(_keyIsHighContrastEnabled, value);
    return result;
  }
}
