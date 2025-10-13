import 'package:fl_ui_config/src/widget/stateful_widget_with_ui_config.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'asset.dart';

abstract class LocalImage extends Asset {
  const LocalImage({
    /// Default image path, e.g. for light mode
    /// Example value: 'packages/your_library/assets/logo.svg'
    required String path,

    /// Optional the image path for dark mode
    /// Example value: 'packages/your_library/assets/logo-dark.svg'
    String? pathDark,
    String? pathHighContrast,
    String? pathDarkHighContrast,
  })  : _path = path,
        _pathDark = pathDark,
        _pathHighContrast = pathHighContrast,
        _pathDarkHighContrast = pathDarkHighContrast;

  /// Default image path, e.g. for light mode
  /// Example value: 'packages/your_library/assets/logo.svg'
  final String _path;

  /// Optional the image path for dark mode
  /// Example value: 'packages/your_library/assets/logo-dark.svg'
  final String? _pathDark;

  final String? _pathHighContrast;
  final String? _pathDarkHighContrast;

  String get path {
    final isDark = brightness == Brightness.dark;
    if (isHighContrastEnabled) {
      if (isDark && _pathDarkHighContrast != null) {
        return _pathDarkHighContrast;
      }
      if (_pathHighContrast != null) {
        return _pathHighContrast;
      }
    }

    if (isDark && _pathDark != null) {
      return _pathDark;
    }

    return _path;
  }
}

class LocalImageAsset extends LocalImage {
  const LocalImageAsset({
    required super.path,
    super.pathDark,
  });

  @override
  Widget build({
    required BuildContext context,
    double? width,
    double? height,
    bool? fitHeight,
    bool? fitWidth,
    String? alternativeMode,
  }) {
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: fitHeight == true
          ? BoxFit.fitHeight
          : fitWidth == true
              ? BoxFit.fitWidth
              : null,
    );
  }
}

class LocalVectorImageAsset extends LocalImage {
  const LocalVectorImageAsset({
    required super.path,
    super.pathDark,
  });

  @override
  Widget build({
    required BuildContext context,
    double? width,
    double? height,
    bool? fitHeight,
    bool? fitWidth,
    String? alternativeMode,
  }) {
    return SvgPicture.asset(
      path,
      width: width,
      height: height,
      fit: fitHeight == true
          ? BoxFit.fitHeight
          : fitWidth == true
              ? BoxFit.fitWidth
              : BoxFit.contain,
    );
  }
}
