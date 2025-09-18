import 'package:fl_ui_config/fl_ui_config.dart' as flui;
import 'package:fl_ui_config/src/fonts_config/fonts.dart';
import 'package:flutter/cupertino.dart';

@immutable
class FontsConfig {
  const FontsConfig({
    this.fontFamily = Fonts.roboto,
    this.fontFamilyHeadlines = Fonts.roboto,
    this.fontFamilyButtons = Fonts.roboto,
  });

  final String fontFamily;

  final String fontFamilyHeadlines;

  final String fontFamilyButtons;

  flui.FontColors get fontColors => flui.fontColors;
}
