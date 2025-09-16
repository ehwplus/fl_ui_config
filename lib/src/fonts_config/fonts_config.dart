import 'package:flutter/cupertino.dart';

import 'fonts.dart';

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
}
