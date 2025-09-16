import 'package:flutter/material.dart';

class ThemeModeButton extends StatelessWidget {
  const ThemeModeButton({
    super.key,
    required this.value,
    required this.onChanged,
    this.labels = const ThemeModeLabels(),
    this.style,
  });

  /// current value
  final ThemeMode value;

  final ValueChanged<ThemeMode> onChanged;

  /// labels (localization made easy).
  final ThemeModeLabels labels;

  /// optional: override ButtonStyle for FilledButton.
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final (icon, text) = _iconAndTextFor(value, labels);

    return PopupMenuButton<ThemeMode>(
      tooltip: labels.menuTooltip,
      initialValue: value,
      onSelected: onChanged,
      itemBuilder: (context) => [
        _menuItem(ThemeMode.system, labels.system, Icons.settings_suggest_outlined),
        _menuItem(ThemeMode.light, labels.light, Icons.light_mode_outlined),
        _menuItem(ThemeMode.dark, labels.dark, Icons.dark_mode_outlined),
      ],
      child: Semantics(
        button: true,
        label: '${labels.changeTo}: $text',
        child: FilledButton.icon(
          style:
              style ??
              FilledButton.styleFrom(
                backgroundColor: colorScheme.secondaryContainer,
                foregroundColor: colorScheme.onSecondaryContainer,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                shape: const StadiumBorder(),
              ),
          onPressed: null,
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            transitionBuilder: (c, a) => ScaleTransition(scale: a, child: c),
            child: Icon(icon, key: ValueKey(value)),
          ),
          label: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: Text(
              text,
              key: ValueKey('label-$value'),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }

  PopupMenuItem<ThemeMode> _menuItem(ThemeMode mode, String label, IconData icon) {
    return PopupMenuItem<ThemeMode>(
      value: mode,
      child: Row(children: [Icon(icon), const SizedBox(width: 12), Text(label)]),
    );
  }

  (IconData, String) _iconAndTextFor(ThemeMode mode, ThemeModeLabels l) {
    switch (mode) {
      case ThemeMode.system:
        return (Icons.settings_suggest_outlined, l.system);
      case ThemeMode.light:
        return (Icons.light_mode_outlined, l.light);
      case ThemeMode.dark:
        return (Icons.dark_mode_outlined, l.dark);
    }
  }
}

class ThemeModeLabels {
  const ThemeModeLabels({
    this.system = 'System',
    this.light = 'Light',
    this.dark = 'Dark',
    this.menuTooltip = 'Change Theme Mode',
    this.changeTo = 'Switch to',
  });

  final String system;
  final String light;
  final String dark;
  final String menuTooltip;
  final String changeTo;

  ThemeModeLabels copyWith({String? system, String? light, String? dark, String? menuTooltip, String? changeTo}) {
    return ThemeModeLabels(
      system: system ?? this.system,
      light: light ?? this.light,
      dark: dark ?? this.dark,
      menuTooltip: menuTooltip ?? this.menuTooltip,
      changeTo: changeTo ?? this.changeTo,
    );
  }
}
