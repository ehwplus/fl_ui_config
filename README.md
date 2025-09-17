## fl_ui_config

A small, focused Flutter library to define an app-wide, consistent UI configuration and control it at runtime:

- **Color palettes**: default and alternative palettes
- **Theming**: generate `ThemeData` for light/dark from a `ColorPalette`
- **Persistence**: pluggable `UiConfigManager` (in-memory for tests or `SharedPreferences` for production)
- **Easy integration**: drop-in `MaterialAppWithUiConfig` wrapper
- **Complex integration possible**: Use regular `MaterialApp` instead and use `StatefulWidgetWithUiConfig`.

### Contents
- Overview & features
- Installation
- Quickstart
- Advanced usage (color palettes, `UiConfigManager`)
- Example app
- FAQ
- Planned for the future
- License

---

This is a screenshot of the demo application where you can switch between dark and light mode as well as the color palette.

<img width="1459" height="915" alt="Bildschirmfoto 2025-09-17 um 11 37 34" src="https://github.com/user-attachments/assets/a2d65c7d-043a-48d6-a527-903060990fa6" />

---

### Overview & features

- **Central UI configuration** via `UiConfig` (app name, `ColorPalette`, fonts, assets, dark mode)
- **Multiple palettes** through `alternativeColorPalettes`
- **Light/Dark themes** are derived from the selected palette
- **State/persistence** handled by `UiConfigManager` (e.g. `SharedPreferencesUiConfigManager`)
- **Fast start** with `MaterialAppWithUiConfig`

---

### Installation

In your `pubspec.yaml`:

```yaml
dependencies:
  fl_ui_config: ">=0.0.5 <0.1.0"
```

Import in Dart files:

```dart
import 'package:fl_ui_config/fl_ui_config.dart';
```

---

### Quickstart

Minimal example (from `example/lib/main.dart`):

```dart
import 'package:fl_ui_config/fl_ui_config.dart';
import 'package:flutter/material.dart';

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
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text(title)),
      body: const Center(child: Text('Hello Ui Config!')),
    );
  }
}
```

This example:
- creates a `UiConfig` with default and alternative palettes,
- wraps the app with `MaterialAppWithUiConfig`,
- uses `TesterUiConfigManager` (in-memory; handy for local testing).

Inside the app simply call `uiConfig`, `colorPalette`, `assets`, `fonts`, 
`alternativeColorPaletteKey` or `isHighContrastEnabled`. There is no need to use `BuildContext` 
to read a ui config value.

---

### Advanced usage

#### Define color palettes

```dart
final config = UiConfig(
  appName: 'My App',
  defaultColorPalette: ColorPalette.fromMaterialColor(primary: Colors.blue),
  alternativeColorPalettes: {
    'green': ColorPalette.fromMaterialColor(primary: Colors.green),
  },
);
```

`UiConfig` derives `ThemeData` for light and dark from your palette:

```dart
final light = config.lightTheme(alternativeMode: 'green');
final dark = config.darkTheme(alternativeMode: 'green');
```

#### Choose a UiConfigManager

- **TesterUiConfigManager**: in-memory with artificial delay — great for local testing
- **SharedPreferencesUiConfigManager**: persists the selection on the device

```dart
final manager = SharedPreferencesUiConfigManager(
  sharedPreferences: await SharedPreferences.getInstance(),
);

MaterialAppWithUiConfig(
  uiConfig: config,
  uiConfigManager: manager,
  title: 'My App',
  home: const Home(),
);
```

The manager saves/loads:
- the selected alternative palette key (`String?`)
- the `ThemeMode` (system/light/dark)
- the high-contrast flag (`bool`)

#### Build your own settings UI

Use `StatefulWidgetWithUiConfig` to build a custom settings screen; the builder provides the current values:

```dart
StatefulWidgetWithUiConfig(
  uiConfig: config,
  uiConfigManager: manager,
  builder: ({
    required ThemeMode themeMode,
    required bool isHighContrastEnabled,
    String? alternativeColorPaletteKey,
  }) {
    // build your settings here (dropdown for palette, switches for theme etc.)
    return YourSettingsWidget(...);
  },
);
```

---

### Example app

A more complete demo is available under `example/`.

Run it locally:

```bash
cd example
flutter run
```

---

### FAQ

- **How do I disable dark mode?**
  Set `isDarkModeEnabled: false` in `UiConfig`. Then `darkTheme` will be `null`.

- **Can I use custom fonts/assets?**
  Yes, via `FontsConfig` and `AssetsConfig` in `UiConfig`.

- **How do I change the palette programmatically?**
  Use the selected `UiConfigManager` by calling `context.saveAlternativeColorPaletteKey(...)`.

---

### Planned for the future

- Support high contrast themes
- Add sizes (margins, paddings, radius, ...)
- Continue implementation of asset management

---

### License

This project is licensed under the BSD 3 License. See `LICENSE`.
