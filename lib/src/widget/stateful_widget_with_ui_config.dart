import 'package:fl_ui_config/fl_ui_config.dart';
import 'package:flutter/material.dart';

import 'theme_controller.dart';

/// Bundle of UI settings provided by [StatefulWidgetWithUiConfig]'s builder.
typedef UiSettings = ({String? alternativeColorPaletteKey, ThemeMode themeMode, bool isHighContrastEnabled});

final _themeController = ThemeController();

/// A stateful wrapper that loads, exposes and persists UI configuration
/// (theme mode, color palette, high contrast) via a [UiConfigManager],
/// and rebuilds its child using the provided [builder].
class StatefulWidgetWithUiConfig extends StatefulWidget {
  const StatefulWidgetWithUiConfig({
    super.key,
    required this.builder,
    required this.uiConfig,
    this.placeholderWidget,
    required this.uiConfigManager,
    this.defaultThemeMode = ThemeMode.system,
    this.defaultColorPaletteKey,
  });

  /// The central UI configuration (palettes, fonts, assets).
  final UiConfig uiConfig;

  /// Optional widget rendered while settings are being loaded.
  final Widget? placeholderWidget;

  /// The default color palette key used when no persisted value exists.
  /// If the user never changed the palette, this value can remain null.
  final String? defaultColorPaletteKey;

  /// The default theme mode used when no persisted value exists.
  final ThemeMode defaultThemeMode;

  /// Builder invoked when the UI settings are available and whenever they change.
  /// Implement your UI that reacts to [alternativeColorPaletteKey], [themeMode]
  /// and [isHighContrastEnabled].
  final Widget Function({
    String? alternativeColorPaletteKey,
    required ThemeMode themeMode,
    required bool isHighContrastEnabled,
  }) builder;

  /// Manager responsible for loading and saving UI-related preferences.
  final UiConfigManager uiConfigManager;

  /// Current alternative palette key if one is selected; otherwise null.
  String? get alternativeMode => null;

  @override
  State<StatefulWidget> createState() {
    return ClientConfigState();
  }

  /// Retrieves the nearest [ClientConfigState] from the widget tree.
  ///
  /// Throws an assertion error in debug mode if the widget is missing.
  static ClientConfigState of(BuildContext context) {
    final ClientConfigState? result = context.findAncestorStateOfType<ClientConfigState>();
    assert(result != null, 'No StatefulWidgetWithClientConfig found in context. Did you forget to wrap your app?');
    return result!;
  }
}

/// State that holds and mutates the current UI settings and persists them
/// through the provided [UiConfigManager].
class ClientConfigState extends State<StatefulWidgetWithUiConfig> {
  /// Lazy initialization future for loading persisted settings.
  late final Future<UiSettings> _initFuture = _load();

  late String? _alternativeColorPaletteKey;

  /// Currently selected alternative color palette key, or null when default.
  String? get alternativeColorPaletteKey => _alternativeColorPaletteKey;

  late ThemeMode _themeMode;

  /// Currently selected theme mode.
  ThemeMode get themeMode => _themeMode;

  late bool _isHighConstrastEnabled;

  /// Whether high-contrast mode is enabled.
  bool get isHighConstrastEnabled => _isHighConstrastEnabled;

  /// Convenience access to the provided [UiConfig].
  UiConfig get uiConfig => widget.uiConfig;

  @override
  void initState() {
    super.initState();
    _globalUiConfigSettings = _GlobalUiConfigSettings(
      alternativeColorPaletteKey: widget.uiConfigManager.loadAlternativeColorPaletteKey(),
      themeMode: widget.defaultThemeMode,
      isHighContrastEnabled: false,
      uiConfig: uiConfig,
      brightness: Theme.of(context).brightness,
    );
  }

  /// Saves a new alternative color palette key and updates local state.
  Future<void> saveAlternativeColorPaletteKey(String? value) async {
    _updateAlternativeColorPaletteKey(value);
    await widget.uiConfigManager.saveAlternativeColorPaletteKey(value);
  }

  /// Saves a new [ThemeMode] and updates local state.
  Future<void> saveThemeMode(ThemeMode value) async {
    _updateThemeMode(value);
    _themeController.setMode(value);
    await widget.uiConfigManager.saveThemeMode(value);
  }

  /// Saves the high-contrast flag and updates local state.
  Future<void> saveIsHighContrastEnabled(bool value) async {
    _updateIsHighContrastEnabled(value);
    await widget.uiConfigManager.saveIsHighContrastEnabled(value);
  }

  /// Loads initial settings from the [UiConfigManager] and applies defaults
  /// from [defaultColorPaletteKey] and [defaultThemeMode] when not set.
  Future<UiSettings> _load() async {
    final alternativeColorPaletteKey =
        widget.uiConfigManager.loadAlternativeColorPaletteKey() ?? widget.defaultColorPaletteKey;
    final themeModeRawValue = widget.uiConfigManager.loadThemeMode();
    final themeMode = ThemeMode.values.firstWhere((v) => v == themeModeRawValue, orElse: () => widget.defaultThemeMode);
    final isHighContrastEnabled = widget.uiConfigManager.loadIsHighContrastEnabled();

    _updateAlternativeColorPaletteKey(alternativeColorPaletteKey, updateState: false);
    _updateThemeMode(themeMode, updateState: false);
    _updateIsHighContrastEnabled(isHighContrastEnabled, updateState: false);
    return (
      alternativeColorPaletteKey: alternativeColorPaletteKey,
      themeMode: themeMode,
      isHighContrastEnabled: isHighContrastEnabled,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Directionality.maybeOf(context) ?? TextDirection.ltr,
      child: FutureBuilder<UiSettings>(
        future: _initFuture,
        builder: (_, snapshot) {
          final brightness = themeMode == ThemeMode.system
              ? MediaQuery.of(context).platformBrightness
              : themeMode == ThemeMode.dark
                  ? Brightness.dark
                  : Brightness.light;
          _globalUiConfigSettings = _GlobalUiConfigSettings(
            alternativeColorPaletteKey: alternativeColorPaletteKey,
            themeMode: themeMode,
            isHighContrastEnabled: isHighConstrastEnabled,
            uiConfig: widget.uiConfig,
            brightness: brightness,
          );
          return snapshot.hasData
              ? AnimatedBuilder(
                  animation: _themeController,
                  builder: (_, __) {
                    return widget.builder(
                      alternativeColorPaletteKey: alternativeColorPaletteKey,
                      themeMode: themeMode,
                      isHighContrastEnabled: isHighConstrastEnabled,
                    );
                  })
              : widget.placeholderWidget ?? const Center(child: Text('Waiting for user interface settings'));
        },
      ),
    );
  }

  /// Updates the current [ThemeMode] and triggers a rebuild when requested.
  void _updateThemeMode(ThemeMode value, {bool updateState = true}) {
    _themeMode = value;
    if (updateState) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    }
  }

  /// Updates the current alternative palette key and triggers a rebuild when requested.
  void _updateAlternativeColorPaletteKey(String? value, {bool updateState = true}) {
    _alternativeColorPaletteKey = value;
    if (updateState) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    }
  }

  /// Updates the high-contrast flag and triggers a rebuild when requested.
  void _updateIsHighContrastEnabled(bool value, {bool updateState = true}) {
    _isHighConstrastEnabled = value;
    if (updateState) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    }
  }
}

@immutable
class _GlobalUiConfigSettings {
  const _GlobalUiConfigSettings({
    required this.alternativeColorPaletteKey,
    required this.themeMode,
    required this.isHighContrastEnabled,
    required this.uiConfig,
    required this.brightness,
  });

  final String? alternativeColorPaletteKey;

  final ThemeMode themeMode;

  final bool isHighContrastEnabled;

  final UiConfig uiConfig;

  final Brightness brightness;

  /// The configured [AssetsConfig].
  AssetsConfig get assets {
    return uiConfig.assets;
  }

  /// The currently active [ColorPalette] derived from the selected key.
  ColorPalette get colorPalette {
    return uiConfig.getColorPalette(brightness: brightness, alternativeMode: alternativeColorPaletteKey);
  }

  /// The configured [FontsConfig].
  FontsConfig get fonts {
    return uiConfig.fonts;
  }
}

late _GlobalUiConfigSettings _globalUiConfigSettings;

@visibleForTesting
void initializeGlobalUiConfigSettingsForWidgetTests({required UiConfig uiConfig}) {
  _globalUiConfigSettings = _GlobalUiConfigSettings(
    alternativeColorPaletteKey: null,
    brightness: Brightness.light,
    isHighContrastEnabled: false,
    themeMode: ThemeMode.system,
    uiConfig: uiConfig,
  );
}

FontColors get fontColors {
  final brightness = _globalUiConfigSettings.brightness;
  return _globalUiConfigSettings.colorPalette.getFontColors(brightness);
}

/// The currently active [ColorPalette] derived from the selected key.
ColorPalette get colorPalette {
  return _globalUiConfigSettings.colorPalette;
}

ColorPalette get colorPaletteLight {
  return uiConfig.getColorPalette(brightness: Brightness.light, alternativeMode: alternativeColorPaletteKey);
}

ColorPalette get colorPaletteDark {
  return uiConfig.getColorPalette(brightness: Brightness.dark, alternativeMode: alternativeColorPaletteKey);
}

/// The configured [AssetsConfig].
AssetsConfig get assets {
  return _globalUiConfigSettings.uiConfig.assets;
}

/// The configured [FontsConfig].
FontsConfig get fontsConfig {
  return _globalUiConfigSettings.uiConfig.fonts;
}

/// Whether high-contrast mode is enabled.
bool get isHighContrastEnabled {
  return _globalUiConfigSettings.isHighContrastEnabled;
}

/// Access the current [UiConfig].
UiConfig get uiConfig {
  return _globalUiConfigSettings.uiConfig;
}

/// The selected alternative palette key or null when default.
String? get alternativeColorPaletteKey {
  return _globalUiConfigSettings.alternativeColorPaletteKey;
}

ThemeMode get themeMode {
  return _globalUiConfigSettings.themeMode;
}

Brightness get brightness {
  return _globalUiConfigSettings.brightness;
}
