import 'package:fl_ui_config/src/color_palette/color_grey.dart';
import 'package:flutter/material.dart';

import 'font_colors.dart';

/// Backup color to directly visualize if a undefined color is in use.
const Color colorNotDefined = Color(0xFFFF13F0);

@immutable
class ColorPalette {
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

  final Color errorLight;
  final Color? errorDark;

  final Color successLight;
  final Color? successDark;

  final Color? warningLight;
  final Color? warningDark;

  final Map<String, String>? replacementMap;

  static ColorPalette fromMaterialColor({
    required MaterialColor primary,
    MaterialColor? secondary,
    MaterialColor? tertiary,
    MaterialColor? quaternary,
  }) {
    return ColorPalette(
      basic0: BaseColors.gray0,
      basic: BaseColors.gray,
      primary: primary,
      secondary: secondary,
      tertiary: tertiary,
      quaternary: quaternary,
      errorLight: Colors.red.shade200,
      errorDark: Colors.red,
      successLight: Colors.green.shade200,
      successDark: Colors.green,
      warningLight: Colors.yellow.shade400,
      warningDark: Colors.yellow.shade900,
    );
  }

  Color getErrorColor(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark && errorDark != null ? errorDark! : errorLight;
  }

  Color getSuccessColor(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark && successDark != null ? successDark! : successLight;
  }

  Color? getWarningColor(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark && warningDark != null ? warningDark! : warningLight;
  }

  const ColorPalette({
    required this.basic0,
    required this.basic,
    required this.primary,
    this.secondary,
    this.tertiary,
    this.quaternary,
    required this.errorLight,
    required this.errorDark,
    required this.successLight,
    required this.successDark,
    this.warningLight,
    this.warningDark,
    this.replacementMap,
  });

  // Background Colors

  Color getBackgroundColor(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? backgroundLight : backgroundDark;
  }

  Color get backgroundLight => basic0;

  Color get backgroundDark => basic.shade900;

  Color get seedColor => primary;

  // AppBar Background Colors

  Color getAppBarBackgroundColor(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? appBarBackgroundColorLight : appBarBackgroundColorDark;
  }

  Color get appBarBackgroundColorLight => backgroundLight;

  Color get appBarBackgroundColorDark => backgroundDark;

  // Card Colors

  Color getCardColor(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? cardColorLight : cardColorDark;
  }

  Color get cardColorLight => basic0;

  Color get cardColorDark => primary.shade900;

  FontColors getFontColors(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? fontColorsDark : fontColorsLight;
  }

  // Font Colors

  FontColors get fontColorsLight => FontColors(
        normal: basic.shade900,
        normalInverted: basic0,
        link: primary.shade500,
        description: basic.shade600,
        disabled: basic.shade400,
        success: successDark ?? successLight,
        failure: errorDark ?? errorLight,
      );

  FontColors get fontColorsDark => FontColors(
        normal: basic0,
        normalInverted: basic.shade900,
        link: primary.shade500,
        description: basic.shade400,
        disabled: basic.shade600,
        success: successLight,
        failure: errorLight,
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
