import 'package:fl_ui_config/src/ui_config_manager/ui_config_manager.dart';
import 'package:flutter/material.dart';

class TesterUiConfigManager extends UiConfigManager {
  TesterUiConfigManager({this.delayInMillis = 500});

  static const ThemeMode _defaultUiMode = ThemeMode.system;
  static const bool _defaultIsHighContrastEnabled = false;

  ThemeMode? _uiMode;

  String? _alternativeColorPaletteKey;

  bool _isHighContrastEnabled = _defaultIsHighContrastEnabled;

  final int delayInMillis;

  @override
  bool loadIsHighContrastEnabled() {
    return _isHighContrastEnabled;
  }

  @override
  Future<bool> saveIsHighContrastEnabled(bool value) async {
    await Future<dynamic>.delayed(Duration(milliseconds: delayInMillis));
    _isHighContrastEnabled = value;
    return true;
  }

  @override
  ThemeMode loadThemeMode() {
    return _uiMode ?? _defaultUiMode;
  }

  @override
  Future<bool> saveThemeMode(ThemeMode value) async {
    await Future<dynamic>.delayed(Duration(milliseconds: delayInMillis));
    _uiMode = value;
    return true;
  }

  @override
  String? loadAlternativeColorPaletteKey() {
    return _alternativeColorPaletteKey;
  }

  @override
  Future<bool> saveAlternativeColorPaletteKey(String? value) async {
    await Future<dynamic>.delayed(Duration(milliseconds: delayInMillis));
    _alternativeColorPaletteKey = value;
    return true;
  }
}
