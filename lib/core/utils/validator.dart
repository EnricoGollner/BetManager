import 'dart:io';

import 'package:flutter/material.dart';
class Validator {

  static String? isRequired(String? text, {required String fieldLabel}) {
    if (text == null || text.trim().isEmpty) {
      return 'O campo \'$fieldLabel\' é obrigatório';
    }
    return null;
  }
  
  ///Método para validar se o número está terminando com as casas decimais de forma correta
  static void handleDecimal(TextEditingController controller, {int decimalRange = 2}){
      String signal = Platform.localeName == 'pt_BR' ? ',' : '.';
      String value = controller.text;
      if(value.isNotEmpty){
        if (!value.contains(signal)) {
          value += signal;
        }

        List<String> parts = value.split(signal);
        String decimalPart = parts.length > 1 ? parts[1] : '';
        int currentDecimalRange = decimalPart.length;

        if (currentDecimalRange < decimalRange) {
          int zerosToAdd = decimalRange - currentDecimalRange;
          String zeros = '0' * zerosToAdd;

          controller.value = controller.value.copyWith(
            text: '$value$zeros',
            selection: TextSelection.collapsed(offset: '$value$zeros'.length),
          );
        }
      }
    }
}