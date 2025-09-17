import 'package:fl_ui_config/fl_ui_config.dart';

Map<String, String>? generateReplacementMap(
    {required ColorPalette original, required ColorPalette replacement}) {
  final allShadesOriginal = [
    ...original.primary.allShades,
    if (original.secondary != null && replacement.secondary != null)
      ...original.secondary!.allShades,
    if (original.tertiary != null && replacement.tertiary != null)
      ...original.tertiary!.allShades,
    if (original.quaternary != null && replacement.quaternary != null)
      ...original.quaternary!.allShades,
  ];
  final allShadesReplacement = [
    ...replacement.primary.allShades,
    if (original.secondary != null && replacement.secondary != null)
      ...replacement.secondary!.allShades,
    if (original.tertiary != null && replacement.tertiary != null)
      ...replacement.tertiary!.allShades,
    if (original.quaternary != null && replacement.quaternary != null)
      ...replacement.quaternary!.allShades,
  ];
  final map = {
    for (int i = 0; i < allShadesOriginal.length; i++)
      allShadesOriginal[i]: allShadesReplacement[i]
  };
  return map.map<String, String>((key, value) {
    return MapEntry(key.toHexString(), value.toHexString());
  });
}
