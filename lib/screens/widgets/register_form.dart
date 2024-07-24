import 'package:bet_manager_app/core/theme/colors.dart';
import 'package:bet_manager_app/core/theme/ui_responsivity.dart';
import 'package:bet_manager_app/core/utils/decimal_text_input_formatter.dart';
import 'package:bet_manager_app/core/utils/validator.dart';
import 'package:bet_manager_app/screens/widgets/custom_icon.dart';
import 'package:bet_manager_app/screens/widgets/custom_primary_button.dart';
import 'package:bet_manager_app/screens/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class RegisterForm extends StatefulWidget {
  final Future<void> Function(bool isIncome, {required String amountText}) registerTransaction;
  
  const RegisterForm({
    super.key,
    required this.registerTransaction,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController ctrlAmount = TextEditingController();
  bool isIncome = true;

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
          child: Builder(
            builder: (context) {
              return Scaffold(
                backgroundColor: Colors.transparent,
                body: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.of(context).pop(),
                  child: GestureDetector(
                    onTap: () {},
                    child: Center(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.all(20.s),
                          width: 300.s,
                          decoration: BoxDecoration(
                            color: modalFormBackground,
                            borderRadius: BorderRadius.circular(20.s),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Nova Transação',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                                  ),
                                  IconButton(
                                    splashRadius: 20.s,
                                    icon: const CustomIcon(
                                      iconData: Icons.close,
                                      color: backgroundColor,
                                    ),
                                    onPressed: () {
                                      ctrlAmount.clear();
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                              Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(height: 20.s),
                                    SizedBox(
                                      width: 100.s,
                                      child: CustomTextField(
                                          autofocus: true,
                                          controller: ctrlAmount,
                                          validatorFunction: (text) => Validator.isRequired(text, fieldLabel: 'Valor'),
                                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                          prefixIcon: Icons.money,
                                          label: 'Valor:',
                                          hintText: 'Insira o valor do registro...',
                                          enableButtonCleanValue: true,
                                          inputFormatters: [
                                            DecimalTextInputFormatter.signal,
                                            DecimalTextInputFormatter(),
                                          ],
                                        ),
                                    ),
                                    SizedBox(height: 20.s),
                                    StatefulBuilder(
                                      builder: (context, setState) {
                                        return Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            ChoiceChip(
                                              selected: isIncome,
                                              selectedColor: incomeBackgroundColor,
                                              label: Text('Ganhos', style: TextStyle(color: isIncome ? surfaceColor : bodyTextColorBlack),),
                                              onSelected: (newValue) {
                                                setState(() {
                                                  if (isIncome) return;
                                                  isIncome = true;
                                                });
                                              },
                                            ),
                                            SizedBox(width: 15.s),
                                            ChoiceChip(
                                              // color: WidgetStateProperty.resolveWith(
                                              //   (states) {
                                              //     if (!states.contains(WidgetState.selected)) {
                                              //       return bodyTextColor;
                                              //     }
                                              //     return null;
                                              //   },
                                              // ),
                                              selected: !isIncome,
                                              selectedColor: primaryColor,
                                              label: Text('Depósito', style: TextStyle(color: !isIncome ? surfaceColor : bodyTextColorBlack),),
                                              onSelected: (newValue) {
                                                setState(() {
                                                  if (!isIncome) return;
                                                  isIncome = false;
                                                });
                                              },
                                            ),
                                          ],
                                        );
                                      }
                                    ),
                                    SizedBox(height: 20.s),
                                    CustomPrimaryButton(
                                      isLoading: false,
                                      text: 'SALVAR',
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          await  widget.registerTransaction(isIncome, amountText: ctrlAmount.text);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
  }
}