import 'package:flutter/material.dart';

class BaseColors {
  static const gray0 = Color(0xFFFAFAFA);
  static const MaterialColor gray = MaterialColor(
    0xFF888888, // Default (500)
    <int, Color>{
      0: gray0,
      50: Color(0XFFEFEFEF),
      100: Color(0XFFE0E0E0),
      200: Color(0XFFCBCBCB),
      300: Color(0XFFB8B8B8),
      400: Color(0XFFA9A9A9),
      500: Color(0XFF898989),
      600: Color(0XFF5F5F5F),
      700: Color(0XFF494949),
      800: Color(0XFF2D2D2D),
      900: Color(0XFF0D0D0D),
    },
  );
}
