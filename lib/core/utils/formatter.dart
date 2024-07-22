import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class Formatter {
  static String formatDatetime(DateTime dateTime) {
    initializeDateFormatting();
    final DateFormat dateFormat = DateFormat.yMd('pt_BR');
    return dateFormat.format(dateTime.toLocal());
  }

  static Uint8List? imageBytesFromBase64String(String? base64String) {
    if (base64String == null) return null; // rare case
    return base64Decode(base64String);
  }

  ///Formata para obter nomenclatura comum
  static String getVernacularName(String specie) => specie.split(' (').last.replaceAll(')', '');

  //Formatação para obter a nomenclatura binominal da espécie que está entre parênteses
  static String getLatimName(String specie) {
    final String latimName = specie.split(' (').first;
    return latimName;
  }

  ///Método para formatar o value para moeda brasileira
  static String doubleToCurrency(double value) {
    return NumberFormat.currency(symbol: "R\$ ").format(value);
  }

  
  ///Método para formatar o valor do texto para numero (como o caso de valores em moeda)
  static double currencyToDouble(String text) {
    if (text.isEmpty) {
      return 0.0;
    } else {
      text = text.replaceAll('R\$ ', '');

      if (Platform.localeName == 'pt_BR') {
          text = text.replaceAll('.', '');
          text = text.replaceAll(',', '.');
        } else if (Platform.localeName == 'en_US') {
          text = text.replaceAll(',', '');
        }
        return double.parse(text);
    }
  }

}