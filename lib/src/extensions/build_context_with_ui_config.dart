import 'package:fl_ui_config/fl_ui_config.dart'
    show
        UiConfig,
        StatefulWidgetWithUiConfig,
        ColorPalette,
        AssetsConfig,
        FontsConfig;
import 'package:flutter/material.dart';

/// Convenience extensions to access UI config and persist settings from any [BuildContext].
extension UiConfigStatefulWidgetExtension on BuildContext {
  /// Access the current [UiConfig].
  UiConfig get uiConfig {
    return StatefulWidgetWithUiConfig.of(this).uiConfig;
  }

  /// The selected alternative palette key or null when default.
  String? get alternativeColorPaletteKey {
    final app = StatefulWidgetWithUiConfig.of(this);
    return app.alternativeColorPaletteKey;
  }

  /// The currently active [ColorPalette] derived from the selected key.
  ColorPalette get colorPalette {
    final app = StatefulWidgetWithUiConfig.of(this);
    final brightness = Theme.of(this).brightness;
    return app.uiConfig.getColorPalette(
        brightness: brightness,
        alternativeMode: app.alternativeColorPaletteKey);
  }

  /// The configured [AssetsConfig].
  AssetsConfig get assets {
    final app = StatefulWidgetWithUiConfig.of(this);
    return app.uiConfig.assets;
  }

  /// The configured [FontsConfig].
  FontsConfig get fonts {
    final app = StatefulWidgetWithUiConfig.of(this);
    return app.uiConfig.fonts;
  }

  /// Whether high-contrast mode is enabled.
  bool get isHighContrastEnabled {
    final app = StatefulWidgetWithUiConfig.of(this);
    return app.isHighConstrastEnabled;
  }

  /// The current [ThemeMode].
  ThemeMode get themeMode {
    final app = StatefulWidgetWithUiConfig.of(this);
    return app.themeMode;
  }

  /// Persists a new alternative palette key and updates UI.
  Future<void> saveAlternativeColorPaletteKey(String? value) async {
    final app = StatefulWidgetWithUiConfig.of(this);
    await app.saveAlternativeColorPaletteKey(value);
  }

  /// Persists the high-contrast flag and updates UI.
  Future<void> saveIsHighContrastEnabled(bool value) async {
    final app = StatefulWidgetWithUiConfig.of(this);
    await app.saveIsHighContrastEnabled(value);
  }

  /// Persists a new [ThemeMode] and updates UI.
  Future<void> saveThemeMode(ThemeMode value) async {
    final app = StatefulWidgetWithUiConfig.of(this);
    await app.saveThemeMode(value);
  }
}
