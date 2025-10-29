# 0.1.4

* Fix: text selection color at dark theme

# 0.1.3

* Improvement: Add AnimatedContainer for smoother change between dark and light theme
* Fix: getAppBarBackgroundColor should not return dark theme color for light
* Improvement: Default app bar color taken from primary color palette

# 0.1.2

* Refactor: Use material import instead of new widgets mimport to resolve "The getter 'Brightness' isn't defined for the class 'LocalImage'."

# 0.1.1

* Feat: Add getter colorPaletteLight and colorPaletteDark

# 0.1.0

* Feat: Asset and ImageAsset exposed. Requires full path to image file.

# 0.0.10

* Minor fix: getSuccessColor, getWarningColor condition

## 0.0.9

* Fix: Access to dark color palette without context

## 0.0.8

* Add global getters for [uiConfig], [colorPalette], [assets], [fontsConfig], [fontColors], [alternativeColorPaletteKey] and [isHighContrastEnabled];

## 0.0.4

* Allow to use another ColorPalette for brightness dark
* Rename colors error, success and warning
* Fix: Expose FontColors if app wants to override fontColors getter inside ColorPalette

## 0.0.1

* Be able to handle ThemeMode and ColorPalette with MaterialAppWithUiConfig