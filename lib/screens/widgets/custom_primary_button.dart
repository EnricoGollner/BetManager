import 'package:bet_manager_app/core/theme/colors.dart';
import 'package:bet_manager_app/core/theme/ui_responsivity.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomPrimaryButton extends StatelessWidget {
  final bool isLoading;
  final String text;
  final VoidCallback? onPressed;
  final Color? color;

  const CustomPrimaryButton({
    super.key,
    required this.isLoading,
    required this.text,
    this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
        return Shimmer.fromColors(
          baseColor: primaryColor,
          highlightColor: secondaryColor,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: backgroundColor,
            ),
            width: double.infinity,
            height: 42.s1,
          ),
        );
    } else {
      return SizedBox(
          width: double.infinity,
          height: 42.s1,
          child: ElevatedButton(
            style: _buttonStylePrimary(color),
            onPressed: onPressed,
            child: Text(
              text,
              style: const TextStyle(color: bodyTextColor3),
            ),
          ),
        );
    }
  }

  ButtonStyle _buttonStylePrimary(Color? color) => ElevatedButton.styleFrom(
        // padding: const EdgeInsets.all(12.0),
        backgroundColor: color ?? primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      );
}