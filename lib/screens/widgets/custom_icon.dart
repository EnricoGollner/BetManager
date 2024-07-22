import 'package:bet_manager_app/core/theme/ui_responsivity.dart';
import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  final IconData iconData;
  final Color color;

  const CustomIcon({
    super.key,
    required this.iconData,
    required this.color
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      size: 22.s2,
      color: color,
      iconData,
    );
  }
}
