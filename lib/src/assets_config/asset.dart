import 'package:flutter/widgets.dart';

// Top level class for the future, e.g. to support images from web if necessary.
// ignore: one_member_abstracts
abstract class Asset {
  const Asset();

  Widget build({
    required BuildContext context,
    double? width,
    double? height,
    bool? fitHeight,
    bool? fitWidth,
    String? alternativeMode,
  });
}
