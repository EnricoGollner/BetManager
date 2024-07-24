import 'package:bet_manager_app/core/theme/colors.dart';
import 'package:flutter/material.dart';

class Style {
  static ThemeData get material3Theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        brightness: Brightness.dark,
        surface: backgroundColor,
        onSurface: bodyTextColorBlack,
      ),
      expansionTileTheme: const ExpansionTileThemeData(
        iconColor: bodyTextColor4,
        textColor: bodyTextColor4,
        collapsedBackgroundColor: bodyTextColor4,
      ),
    );
  }
}