import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'asset.dart';

const _packagePath = 'packages/ui_library/';
const _assetsFolderPath = 'assets';

abstract class LocalImage extends Asset {
  const LocalImage();

  String get path;
}

class LocalImageAsset extends LocalImage {
  final String fileName;

  const LocalImageAsset({required this.fileName});

  @override
  String get path => '$_packagePath$_assetsFolderPath/$fileName';

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
  final String fileName;

  const LocalVectorImageAsset({required this.fileName});

  @override
  String get path => '$_packagePath$_assetsFolderPath/$fileName.svg';

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
