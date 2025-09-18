import 'package:fl_ui_config/fl_ui_config.dart' as flui;
import 'package:flutter/cupertino.dart';

@immutable
class FontsConfig {
  const FontsConfig({
    this.fontFamily = flui.Fonts.roboto,
    this.fontFamilyHeadlines = flui.Fonts.roboto,
    this.fontFamilyButtons = flui.Fonts.roboto,
  });

  final String fontFamily;

  final String fontFamilyHeadlines;

  final String fontFamilyButtons;

  flui.FontColors get fontColors => flui.fontColors;
}
