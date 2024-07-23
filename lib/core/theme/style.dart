import 'package:bet_manager_app/core/theme/colors.dart';
import 'package:flutter/material.dart';

class Style {
  static ThemeData get material3Theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        brightness: Brightness.dark,
        surface: backgroundColor,
        onSurface: bodyTextColor5,
        surfaceContainer: bodyTextColor4,
      )
    );
  }
}