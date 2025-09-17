import 'package:fl_ui_config/fl_ui_config.dart';
import 'package:flutter/material.dart';

/// Bundle of UI settings provided by [StatefulWidgetWithUiConfig]'s builder.
typedef UiSettings = ({String? alternativeColorPaletteKey, ThemeMode themeMode, bool isHighContrastEnabled});

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

  /// Saves a new alternative color palette key and updates local state.
  Future<void> saveAlternativeColorPaletteKey(String? value) async {
    _updateAlternativeColorPaletteKey(value);
    await widget.uiConfigManager.saveAlternativeColorPaletteKey(value);
  }

  /// Saves a new [ThemeMode] and updates local state.
  Future<void> saveThemeMode(ThemeMode value) async {
    _updateThemeMode(value);
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
          globalUiConfigSettings = GlobalUiConfigSettings(
            alternativeColorPaletteKey: alternativeColorPaletteKey,
            themeMode: themeMode,
            isHighContrastEnabled: isHighConstrastEnabled,
            uiConfig: widget.uiConfig,
            brightness: Theme.of(context).brightness,
          );
          return snapshot.hasData
              ? widget.builder(
                  alternativeColorPaletteKey: alternativeColorPaletteKey,
                  themeMode: themeMode,
                  isHighContrastEnabled: isHighConstrastEnabled,
                )
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
class GlobalUiConfigSettings {
  const GlobalUiConfigSettings({
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

GlobalUiConfigSettings? globalUiConfigSettings;

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
    return app.uiConfig.getColorPalette(brightness: brightness, alternativeMode: app.alternativeColorPaletteKey);
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
