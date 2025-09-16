import 'package:fl_ui_config/fl_ui_config.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

const appName = 'UiConfig Demo';

final uiConfig = UiConfig(
  appName: 'UiConfig Demo 2',
  defaultColorPalette: ColorPalette.fromMaterialColor(primary: Colors.orange, secondary: Colors.blue),
  alternativeColorPalettes: {
    'yellow': ColorPalette.fromMaterialColor(primary: Colors.yellow, secondary: Colors.blue),
    'red': ColorPalette.fromMaterialColor(primary: Colors.red, secondary: Colors.blue),
  },
);

class ExampleApp2 extends StatelessWidget {
  const ExampleApp2({super.key});

  @override
  Widget build(BuildContext context) {
    return StatefulWidgetWithUiConfig(
      uiConfig: uiConfig,
      uiConfigManager: TesterUiConfigManager(delayInMillis: 0),
      builder:
          ({String? alternativeColorPaletteKey, required ThemeMode themeMode, required bool isHighContrastEnabled}) {
            final lightTheme = uiConfig.lightTheme(alternativeMode: alternativeColorPaletteKey);
            final darkTheme = uiConfig.darkTheme(alternativeMode: alternativeColorPaletteKey);
            return MaterialApp(
              title: appName,
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: themeMode,
              home: const HomePage(title: appName),
            );
          },
    );
  }
}
