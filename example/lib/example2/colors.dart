import 'dart:math';

import 'package:fl_ui_config/fl_ui_config.dart';
import 'package:flutter/material.dart';

class ColorsWidget extends StatelessWidget {
  const ColorsWidget({super.key});

  static const _maxColoredBoxHeight = 16.0 * 3;
  static const _marginHorizontal = 16.0;

  @override
  Widget build(BuildContext context) {
    final colorPalette = context.colorPalette;
    final fontColors = colorPalette.fontColorsLight;
    final Map<String, MaterialColor> materialColors = {
      'Basic': colorPalette.basic,
      'Primary': colorPalette.primary,
      if (colorPalette.secondary != null) 'Secondary': colorPalette.secondary!,
      if (colorPalette.tertiary != null) 'Tertiary': colorPalette.tertiary!,
      if (colorPalette.quaternary != null)
        'Quaternary': colorPalette.quaternary!,
    };

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                children: [
                  for (final entry in materialColors.entries)
                    Builder(
                      builder: (context) {
                        final shades = entry.value.allShades;
                        final double coloredBoxWidth =
                            (constraints.maxWidth -
                                (2 *
                                    _marginHorizontal *
                                    materialColors.length)) /
                            materialColors.length;
                        final double coloredBoxHeight = min(
                          coloredBoxWidth / 2,
                          _maxColoredBoxHeight,
                        );
                        return Column(
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  entry.key,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                            ),
                            for (int i = 0; i < shades.length; i++)
                              Container(
                                width: coloredBoxWidth,
                                height: coloredBoxHeight,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: _marginHorizontal,
                                ),
                                color: shades[i],
                                child: Center(
                                  child: Text(
                                    shades[i].toHexString(),
                                    style: TextStyle(
                                      color: i < 5
                                          ? fontColors.normalInverted
                                          : fontColors.normal,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 32),
          LayoutBuilder(
            builder: (context, constraints) {
              const double marginHorizontal = 16.0;
              final Map<String, Color> colorMap = {
                'Error light': colorPalette.errorLight,
                if (colorPalette.errorDark != null)
                  'Error dark': colorPalette.errorDark!,
                'Success light': colorPalette.successLight,
                if (colorPalette.successDark != null)
                  'Success dark': colorPalette.successDark!,
                if (colorPalette.warningLight != null)
                  'Warn light': colorPalette.warningLight!,
                if (colorPalette.warningDark != null)
                  'Warn dark': colorPalette.warningDark!,
              };
              final double coloredBoxWidth = max(
                (constraints.maxWidth -
                        (2 * marginHorizontal * colorMap.length)) /
                    colorMap.length,
                200,
              );
              final double coloredBoxHeight = min(
                coloredBoxWidth / 2,
                _maxColoredBoxHeight,
              );
              return Wrap(
                children: [
                  for (int i = 0; i < colorMap.length; i++)
                    SizedBox(
                      width: 200,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                colorMap.keys.toList()[i],
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                          ),
                          Container(
                            width: coloredBoxWidth,
                            height: coloredBoxHeight,
                            margin: const EdgeInsets.symmetric(
                              horizontal: marginHorizontal,
                            ),
                            color: colorMap.values.toList()[i],
                            child: Center(
                              child: Text(
                                colorMap.values.toList()[i].toHexString(),
                                style: TextStyle(
                                  color: i % 2 == 0
                                      ? fontColors.normal
                                      : fontColors.normalInverted,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
