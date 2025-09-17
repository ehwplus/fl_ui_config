import 'package:fl_ui_config/fl_ui_config.dart';
import 'package:fl_ui_config/src/color_palette/color_grey.dart';
import 'package:flutter/material.dart';

/// Backup color to directly visualize if a undefined color is in use.
const Color colorNotDefined = Color(0xFFFF13F0);

@immutable
class ColorPalette {
  const ColorPalette({
    required this.basic0,
    required this.basic,
    required this.primary,
    this.secondary,
    this.tertiary,
    this.quaternary,
    required this.error,
    required this.errorBackground,
    required this.success,
    required this.successBackground,
    this.warning,
    this.warningBackground,
    this.replacementMap,
    this.brightness = Brightness.light,
  });

  /// Color 0 where basic0 is used a default background
  final Color basic0;

  /// Color 0
  final MaterialColor basic;

  /// Color 1
  final MaterialColor primary;

  /// Color 2
  final MaterialColor? secondary;

  /// Color 3
  final MaterialColor? tertiary;

  /// Color 4
  final MaterialColor? quaternary;

  final Color error;
  final Color? errorBackground;

  final Color success;
  final Color? successBackground;

  final Color? warning;
  final Color? warningBackground;

  final Map<String, String>? replacementMap;

  /// If brightness is light,
  final Brightness brightness;

  static ColorPalette fromMaterialColor({
    required MaterialColor primary,
    MaterialColor? secondary,
    MaterialColor? tertiary,
    MaterialColor? quaternary,
    Brightness brightness = Brightness.light,
  }) {
    return ColorPalette(
      basic0: BaseColors.gray0,
      basic: BaseColors.gray,
      primary: primary,
      secondary: secondary,
      tertiary: tertiary,
      quaternary: quaternary,
      errorBackground: Colors.red.shade200,
      error: Colors.red,
      successBackground: Colors.green.shade200,
      success: Colors.green,
      warningBackground: Colors.yellow.shade400,
      warning: Colors.yellow.shade900,
      brightness: brightness,
    );
  }

  Color getErrorColor(BuildContext context) {
    final useLight = context.isLight ||
        errorBackground == null ||
        brightness == Brightness.dark;
    return useLight ? error : errorBackground!;
  }

  Color getSuccessColor(BuildContext context) {
    final useLight = context.isLight ||
        errorBackground == null ||
        brightness == Brightness.dark;
    return useLight ? success : successBackground!;
  }

  Color? getWarningColor(BuildContext context) {
    final useLight = context.isLight ||
        errorBackground == null ||
        brightness == Brightness.dark;
    return useLight ? warning : warningBackground;
  }

  // Background Colors

  Color getBackgroundColor(BuildContext context) {
    return context.isLight || brightness == Brightness.dark
        ? background
        : backgroundDark;
  }

  Color get background => basic0;

  Color get backgroundDark =>
      brightness == Brightness.dark ? basic0 : basic.shade900;

  Color get seedColor => primary;

  // AppBar Background Colors

  Color getAppBarBackgroundColor(BuildContext context) {
    return context.isDark || brightness == Brightness.dark
        ? appBarBackgroundColor
        : appBarBackgroundColorDark;
  }

  Color get appBarBackgroundColor => background;

  Color get appBarBackgroundColorDark => backgroundDark;

  // Card Colors

  Color getCardColor(BuildContext context) {
    return context.isLight || brightness == Brightness.dark
        ? cardColor
        : cardColorDark;
  }

  Color get cardColor => basic0;

  Color get cardColorDark =>
      brightness == Brightness.dark ? basic0 : primary.shade900;

  FontColors getFontColors(Brightness brightness) {
    return brightness == Brightness.light || this.brightness == Brightness.dark
        ? fontColors
        : fontColorsDark;
  }

  // Font Colors

  FontColors get fontColors => FontColors(
        normal: basic.shade900,
        normalInverted: basic0,
        link: primary.shade500,
        description: basic.shade600,
        disabled: basic.shade400,
        success: success,
        failure: error,
      );

  FontColors get fontColorsDark => FontColors(
        normal: basic0,
        normalInverted: basic.shade900,
        link: primary.shade500,
        description: basic.shade400,
        disabled: basic.shade600,
        success: successBackground ?? success,
        failure: errorBackground ?? error,
      );

  // Helpers

  String replaceColors(String svgData) {
    if (replacementMap == null) {
      return svgData;
    }

    String result = svgData;
    for (final entry in replacementMap!.entries) {
      final original = entry.key;
      final replacement = entry.value;
      result = result.replaceAll(original, replacement);
    }
    return result;
  }
}
