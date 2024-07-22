import 'package:bet_manager_app/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomDateTextField extends StatelessWidget {
  final bool enabled;
  final String labelText;
  final VoidCallback selectDate;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final TextEditingController controller;
  final String? Function(String?)? validatorFunction;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String value)? onFieldSubmitted;
  final bool enableButtonCleanValue;
  final FocusNode? focusNode;
  final bool autofocus;
  final int minLines;
  final int maxLines;
  final int? maxLength;

  const CustomDateTextField({
    super.key,
    this.enabled = true,
    required this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    required this.controller,
    this.validatorFunction,
    this.inputFormatters,
    this.onFieldSubmitted,
    this.enableButtonCleanValue = false,
    this.focusNode,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.maxLength,
    required this.selectDate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: TextFormField(
        onTap: enabled ? selectDate : null,
        enabled: enabled,
        readOnly: true,
        showCursor: false,
        keyboardType: TextInputType.none,
        controller: controller,
        cursorColor: bodyTextColor2,
        // style: textFieldStyle,
        minLines: minLines,
        maxLines: maxLines,
        enableInteractiveSelection: false,
        decoration: InputDecoration(
          label: Text(labelText),
          // hintStyle: textFieldHintStyle,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder: _buildDefaultBorder(),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(color: primaryColor, width: 2.2),
          ),
          focusedBorder: _buildDefaultBorder(borderWidth: 2.2),
          contentPadding: const EdgeInsets.all(10),
          prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: bodyTextColor2) : null,
          suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: bodyTextColor2) : null,
        ),
        validator: validatorFunction,
        onFieldSubmitted: onFieldSubmitted,
        inputFormatters: inputFormatters,
      ),
    );
  }

  OutlineInputBorder _buildDefaultBorder({double borderWidth = 1.2}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(7),
      borderSide: BorderSide(color: backgroundAlternativeColor, width: borderWidth),
    );
  }
}
