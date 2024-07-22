import 'package:bet_manager_app/core/theme/colors.dart';
import 'package:bet_manager_app/core/theme/ui_responsivity.dart';
import 'package:bet_manager_app/core/utils/validator.dart';
import 'package:bet_manager_app/screens/widgets/custom_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final bool enableInteractiveSelection;
  final bool enableButtonCleanValue;
  final VoidCallback? cleanValueAditionalFunction;
  final VoidCallback? onPressedSuffixIcon;
  final String? label;
  final TextStyle? labelTextStyle;
  final bool enabled;
  final String hintText;
  final IconData? prefixIcon;
  final IconData? suffixicon;
  final Function(String)? onChanged;
  final bool autocorrect;
  final bool enableSuggestions;
  final double? height;
  final TextEditingController? controller;
  final String? Function(String?)? validatorFunction;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String value)? onFieldSubmitted;
  final String? initialValue;
  final int maxLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final bool isPassword;
  final FocusNode? focusNode;
  final bool autofocus;
  final Function()? onPressed;
  final bool isFilled;
  final void Function()? onEditingComplete;
  final void Function(PointerDownEvent)? onTapOutside;
  final bool handleDecimal;
  final int? handleDecimalRange;
  final TextCapitalization? textCapitalization;

  const CustomTextField({
    super.key,
    this.enabled = true,
    this.enableInteractiveSelection = true,
    this.enableButtonCleanValue = false,
    this.cleanValueAditionalFunction,
    this.onPressedSuffixIcon,
    this.label,
    this.labelTextStyle,
    required this.hintText,
    this.onFieldSubmitted,
    this.autofocus = false,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixicon,
    this.onChanged,
    this.autocorrect = false,
    this.enableSuggestions = true,
    this.height,
    this.controller,
    this.isPassword = false,
    this.keyboardType,
    this.validatorFunction,
    this.inputFormatters,
    this.focusNode,
    this.onPressed,
    this.initialValue,
    this.isFilled = true,
    this.onEditingComplete,
    this.onTapOutside,
    this.handleDecimal = false,
    this.handleDecimalRange,
    this.textCapitalization,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    ///Necessário para checar se o campo perdeu o foco
    if(widget.handleDecimal && widget.focusNode != null){
      widget.focusNode!.addListener(() {
        if (!widget.focusNode!.hasFocus && widget.controller != null) {
          widget.handleDecimalRange != null ? 
          Validator.handleDecimal(widget.controller!, decimalRange: widget.handleDecimalRange!) 
          : Validator.handleDecimal(widget.controller!);
        }
      });
    }
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: widget.label != null,
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 10.0),
                child: Text(
                  widget.label ?? '',
                  // style: widget.labelTextStyle ?? labelStyle,
                ),
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
        SizedBox(
          height: widget.height,
          child: TextFormField(
            onEditingComplete: widget.onEditingComplete,
            onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
            enabled: widget.enabled,
            contextMenuBuilder: (context, editableTextState) => widget.enableInteractiveSelection
              ? AdaptiveTextSelectionToolbar.editableText(editableTextState: editableTextState)
              : const SizedBox(),
            enableInteractiveSelection: widget.enableInteractiveSelection,
            autocorrect: widget.autocorrect,
            enableSuggestions: widget.enableSuggestions,
            maxLength: widget.maxLength,
            onChanged: widget.onChanged,
            focusNode: widget.focusNode,
            autofocus: widget.autofocus,
            onFieldSubmitted: widget.onFieldSubmitted,
            initialValue: widget.initialValue,
            maxLines: widget.maxLines,
            keyboardType: widget.keyboardType,
            textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
            controller: widget.controller,
            validator: widget.validatorFunction,
            inputFormatters: widget.inputFormatters,
            obscureText: _obscureText,
            // style: textFieldStyle,
            decoration: InputDecoration(
              counterText: '',
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: colorError, width: 2),
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: colorError, width: 1),
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              // errorStyle: errorStyle,
              errorMaxLines: 2,
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: bodyTextColor5, width: 2),
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: bodyTextColor5, width: 2),
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: bodyTextColor5, width: 2.5),
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              prefixIcon: widget.prefixIcon != null
                  ? CustomIcon(
                      iconData: widget.prefixIcon!,
                      color: secondaryColor,
                    )
                  : null,
              prefixIconConstraints: BoxConstraints.tight(Size(60, 20.s)),
              suffixIcon: _buildSufixIconWidget(),
              suffixIconConstraints: BoxConstraints.tight(const Size(60, 25)),
              filled: widget.isFilled,
              hintStyle: const TextStyle(
                color: hintColor,
                fontWeight: FontWeight.w400
              ),
              hintText: widget.hintText,
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15.s),
              fillColor: bodyTextColor3,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget? _buildSufixIconWidget() {
    return widget.isPassword
      ? GestureDetector(
        onTap: () => setState(() => _obscureText = !_obscureText),
        child: CustomIcon(
              iconData: _obscureText ? Icons.visibility : Icons.visibility_off,
              color: secondaryColor,
            ),
      )
      : widget.enableButtonCleanValue
        ? GestureDetector(
            onTap: clearTextField,
            child: CustomIcon(
              iconData: Icons.clear,
              color: bodyTextColor5.withOpacity(0.4),
            ),
          )
        : widget.suffixicon != null ? GestureDetector(
            onTap: widget.onPressedSuffixIcon,
            child: CustomIcon(
              iconData: widget.suffixicon!,
              color: secondaryColor,
            ),
          ) : null;
  }

  ///Método para limpar os valores inseridos no textfield e executar a ação customizada caso seja passada como parâmetro
  void clearTextField() {
    widget.controller!.clear();
    widget.cleanValueAditionalFunction?.call();
  }
}
