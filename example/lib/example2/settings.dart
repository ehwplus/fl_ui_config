import 'package:example/example2/setting_color_palette.dart';
import 'package:example/example2/setting_theme_mode.dart';
import 'package:fl_ui_config/fl_ui_config.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        ThemeModeButton(
          value: context.themeMode,
          onChanged: (selected) {
            context.saveThemeMode(selected);
          },
        ),
        SettingColorPalette(
          alternativeColorPaletteKey: context.alternativeColorPaletteKey,
          onChanged: (selected) {
            context.saveAlternativeColorPaletteKey(selected);
          },
        ),
      ],
    );
  }
}
