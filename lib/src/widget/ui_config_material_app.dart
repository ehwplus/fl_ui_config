import 'package:fl_ui_config/fl_ui_config.dart';
import 'package:flutter/material.dart';

class MaterialAppWithUiConfig extends StatelessWidget {
  const MaterialAppWithUiConfig({
    required this.uiConfig,
    required this.uiConfigManager,
    // from MaterialApp
    super.key,
    required this.title,
    this.themeMode = ThemeMode.system,
    this.home,
    this.builder,
    this.routes = const <String, WidgetBuilder>{},
    this.onGenerateRoute,
    this.navigatorObservers = const <NavigatorObserver>[],
    this.placeholderWidget,
  });

  final UiConfig uiConfig;
  final TesterUiConfigManager uiConfigManager;

  final String title;
  final ThemeMode themeMode;

  final Widget? home;
  final TransitionBuilder? builder;
  final Map<String, WidgetBuilder> routes;
  final RouteFactory? onGenerateRoute;
  final List<NavigatorObserver> navigatorObservers;

  final Widget? placeholderWidget;

  @override
  Widget build(BuildContext context) {
    return StatefulWidgetWithUiConfig(
      uiConfig: uiConfig,
      uiConfigManager: uiConfigManager,
      placeholderWidget: placeholderWidget,
      builder: (
          {String? alternativeColorPaletteKey, required ThemeMode themeMode, required bool isHighContrastEnabled}) {
        final lightTheme = uiConfig.lightTheme(alternativeMode: alternativeColorPaletteKey);
        final darkTheme = uiConfig.darkTheme(alternativeMode: alternativeColorPaletteKey);
        return MaterialApp(
          title: title,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeMode,
          home: home,
          builder: builder,
        );
      },
    );
  }
}
