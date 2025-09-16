import 'package:flutter/material.dart';

extension MaterialColorExtensions on MaterialColor {
  List<Color> get allShades {
    return [
      shade900,
      shade800,
      shade700,
      shade600,
      shade500,
      shade400,
      shade300,
      shade200,
      shade100,
      shade50,
    ];
  }
}
