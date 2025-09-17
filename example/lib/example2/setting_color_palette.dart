import 'package:fl_ui_config/fl_ui_config.dart';
import 'package:flutter/material.dart';

class SettingColorPalette extends StatelessWidget {
  const SettingColorPalette({
    super.key,
    required this.alternativeColorPaletteKey,
    required this.onChanged,
    this.style,
  });

  /// current value
  final String? alternativeColorPaletteKey;

  final ValueChanged<String?> onChanged;

  /// optional: override ButtonStyle for FilledButton.
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final allPalettes = context.uiConfig.allColorPalettes;

    return PopupMenuButton<String?>(
      tooltip: 'Change color palette',
      initialValue: alternativeColorPaletteKey,
      onSelected: onChanged,
      itemBuilder: (context) => [
        for (final paletteEntry in allPalettes.entries)
          _menuItem(paletteEntry.key, paletteEntry.value),
      ],
      child: Semantics(
        button: true,
        label: 'Change color palette',
        child: FilledButton.icon(
          style:
              style ??
              FilledButton.styleFrom(
                backgroundColor: colorScheme.secondaryContainer,
                foregroundColor: colorScheme.onSecondaryContainer,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                shape: const StadiumBorder(),
              ),
          onPressed: null,
          label: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: Text(
              alternativeColorPaletteKey ?? allPalettes.entries.first.key,
              key: ValueKey('label-$alternativeColorPaletteKey'),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }

  PopupMenuItem<String> _menuItem(String label, ColorPalette colorPalette) {
    return PopupMenuItem<String>(
      value: label,
      child: Row(children: [Text(label)]),
    );
  }
}
