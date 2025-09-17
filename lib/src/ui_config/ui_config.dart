import 'package:fl_ui_config/fl_ui_config.dart';
import 'package:flutter/material.dart';

@immutable
class UiConfig {
  /// Human-readable application name used for presentation purposes.
  final String appName;

  /// The primary color palette used when no alternative is selected.
  final ColorPalette defaultColorPalette;

  /// The primary color palette used for brightness dark when no alternative is selected.
  /// If null [defaultColorPalette] is used instead.
  final ColorPalette? defaultColorPaletteDark;

  /// Optional map of alternative palettes accessible by a string key (e.g. 'red').
  /// If a provided key cannot be found, [defaultColorPalette] is used.
  final Map<String, ColorPalette>? alternativeColorPalettes;

  /// Optional map of alternative palettes accessible by a string key (e.g. 'red') for brightness dark.
  /// If a provided key cannot be found, [defaultColorPaletteDark] or [defaultColorPalette] is used.
  /// Note that this will never be used if [defaultColorPaletteDark] is null.
  final Map<String, ColorPalette>? alternativeColorPalettesDark;

  /// Asset-related configuration (icons, images, etc.).
  final AssetsConfig assets;

  /// Font-related configuration (font family and typography).
  final FontsConfig fonts;

  /// Enables providing a dark theme via [darkTheme]. If false, [darkTheme] returns null.
  final bool isDarkModeEnabled;

  /// Creates a new UI configuration for theming, fonts and assets.
  ///
  /// - [appName]: Display name of the app.
  /// - [defaultColorPalette]: Fallback palette when no alternative is selected.
  /// - [alternativeColorPalettes]: Optional map of selectable palettes.
  /// - [fonts]: Font configuration; defaults to [FontsConfig].
  /// - [assets]: Asset configuration; defaults to [AssetsConfig].
  /// - [isDarkModeEnabled]: Whether a dark theme should be generated.
  const UiConfig({
    required this.appName,
    required this.defaultColorPalette,
    this.defaultColorPaletteDark,
    this.alternativeColorPalettes,
    this.alternativeColorPalettesDark,
    this.fonts = const FontsConfig(),
    this.assets = const AssetsConfig(),
    this.isDarkModeEnabled = true,
  });

  /// A combined map of all available palettes including the default one under the key 'default'.
  Map<String, ColorPalette> get allColorPalettes {
    final result = <String, ColorPalette>{
      'default': defaultColorPalette,
      if (alternativeColorPalettes != null)
        for (final entry in alternativeColorPalettes!.entries)
          entry.key: entry.value,
    };
    return result;
  }

  /// Returns the palette for [alternativeMode] if available; otherwise returns [defaultColorPalette].
  ColorPalette getColorPalette(
      {Brightness? brightness, String? alternativeMode}) {
    if (brightness == Brightness.dark && defaultColorPaletteDark != null) {
      final Map<String, ColorPalette>? alternative =
          alternativeColorPalettesDark;
      return (alternativeMode != null && alternative != null
              ? alternative[alternativeMode]
              : null) ??
          defaultColorPaletteDark!;
    }
    final Map<String, ColorPalette>? alternative = alternativeColorPalettes;
    return (alternativeMode != null && alternative != null
            ? alternative[alternativeMode]
            : null) ??
        defaultColorPalette;
  }

  /// Builds a light [ThemeData] based on the selected palette (or default if none is provided).
  ThemeData lightTheme({String? alternativeMode}) {
    final ColorPalette palette = getColorPalette(
        brightness: Brightness.light, alternativeMode: alternativeMode);
    final onSurface = palette.fontColors.normal;
    final onPrimary = palette.fontColors.normalInverted;
    final background = palette.background;
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: palette.primary,
      primarySwatch: palette.primary,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.light,
        seedColor: palette.seedColor,
        primary: palette.primary,
        onPrimary: onPrimary,
        secondary: palette.secondary,
        onSecondary: palette.getFontColors(palette.brightness).normal,
        surface: background,
        onSurface: onSurface,
        primaryContainer: palette.primary,
        error: palette.error,
        errorContainer: palette.error,
        onErrorContainer: palette.fontColors.normal,
      ),
      scaffoldBackgroundColor: background,
      hintColor: palette.fontColors.description,
      fontFamily: fonts.fontFamily,
      textTheme: ThemeData(brightness: Brightness.light)
          .textTheme
          .apply(fontFamily: fonts.fontFamily),
      cardColor: palette.cardColor,
      appBarTheme: AppBarTheme(backgroundColor: palette.appBarBackgroundColor),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: palette.primary,
        foregroundColor: onPrimary,
        iconSize: 32,
      ),
      navigationBarTheme:
          const NavigationBarThemeData(backgroundColor: Colors.white),
    );
  }

  /// Builds a dark [ThemeData] based on the selected palette.
  ///
  /// Returns null if [isDarkModeEnabled] is false to indicate no dark theme is provided.
  ThemeData? darkTheme({String? alternativeMode}) {
    if (!isDarkModeEnabled) {
      return null;
    }
    final ColorPalette palette = getColorPalette(
        brightness: Brightness.dark, alternativeMode: alternativeMode);
    final onSurface = palette.fontColorsDark.normal;
    final onPrimary = palette.fontColorsDark.normalInverted;
    final background = palette.backgroundDark;

    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: palette.primary,
      primarySwatch: palette.primary,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: palette.seedColor,
        primary: palette.primary,
        onPrimary: onPrimary,
        secondary: palette.secondary,
        onSecondary: palette.getFontColors(palette.brightness).normal,
        surface: background,
        onSurface: onSurface,
        primaryContainer: palette.primary,
        error: defaultColorPaletteDark == null
            ? palette.errorBackground
            : palette.error,
        errorContainer: defaultColorPaletteDark == null
            ? palette.error
            : palette.errorBackground,
        onErrorContainer: palette.fontColorsDark.normal,
      ),
      scaffoldBackgroundColor: background,
      hintColor: palette.fontColorsDark.description,
      fontFamily: fonts.fontFamily,
      textTheme: ThemeData(brightness: Brightness.dark)
          .textTheme
          .apply(fontFamily: fonts.fontFamily),
      cardColor: palette.cardColorDark,
      appBarTheme:
          AppBarTheme(backgroundColor: palette.appBarBackgroundColorDark),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: palette.primary,
        foregroundColor: onPrimary,
        iconSize: 32,
      ),
      navigationBarTheme:
          const NavigationBarThemeData(backgroundColor: Colors.black),
    );
  }
}
