import 'package:fl_ui_config/fl_ui_config.dart'
    show UiConfig, ColorPalette, MaterialAppWithUiConfig, TesterUiConfigManager;
import 'package:flutter/material.dart';

// This is a minimalist code example how to use ui config

void main() {
  runApp(const MyApp());
}

const appName = 'UiConfig Demo';

final uiConfig = UiConfig(
  appName: appName,
  defaultColorPalette: ColorPalette.fromMaterialColor(primary: Colors.orange),
  alternativeColorPalettes: {
    'yellow': ColorPalette.fromMaterialColor(primary: Colors.yellow),
    'red': ColorPalette.fromMaterialColor(primary: Colors.red),
  },
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialAppWithUiConfig(
      uiConfig: uiConfig,
      uiConfigManager: TesterUiConfigManager(),
      title: appName,
      home: const MyHomePage(title: appName),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(child: Text('Hello Ui Config!')),
    );
  }
}
