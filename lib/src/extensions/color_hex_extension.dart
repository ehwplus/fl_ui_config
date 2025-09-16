import 'dart:ui';

extension ColorWithHex on Color {
  String toHexString() {
    return '#${(toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }
}
