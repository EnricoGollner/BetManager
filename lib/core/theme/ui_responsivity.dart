import 'dart:io';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';

const int totalColumns = 15;
const int totalRows = 15;
const double mockupWidth = 360.0;
const double mockupHeight = 640.0;

///Classe de responsividade da aplicação
extension ThemeDataExtension on ThemeData {
  double orientedSize(double size) => SizerUtil.orientation == Orientation.portrait ? size.h : size.w;
  double get columnSize => SizerUtil.orientation == Orientation.portrait ? (100 / totalColumns).w : (100 / totalColumns).h;
  double get rowSize => SizerUtil.orientation == Orientation.portrait ? (100 / totalRows).h : (100 / totalRows).w;
  double get maxWidth => SizerUtil.orientation == Orientation.portrait ? 100.0.w : 100.0.h;
  double get maxHeight => SizerUtil.orientation == Orientation.portrait ? 100.0.h : 100.0.w;
}

///Extensão de tamanho criada para o tipo num
extension SizerExt on num {
  ///s = scale (aumentar/diminuir proporcionalmente a largura da tela aplicando o fator de proporcao quando o dispositivo for tablet)
  double get s => this * fator(0);

  double get s1 => this * fator(1);

  double get s2 => this * fator(2);

  double get s3 => this * fator(3);

  ///r = resize (aumentar/diminuir proporcionalmente a largura da tela)
  double get r => this * (SizerUtil.width / mockupWidth);
}

///Retorna o dispositivo usado pelo usuario
DeviceType get device {
  if (Platform.isAndroid || Platform.isIOS) {
    if ((SizerUtil.width < 720)) {
      return DeviceType.mobile;
    } else {
      return DeviceType.tablet;
    }
  } else {
    return SizerUtil.deviceType;
  }
}

double fator(int multiplicador) {
  var limite = 500 + (500 * 0.1 * multiplicador);

  if (device == DeviceType.tablet) {
    return ((SizerUtil.width <= limite ? SizerUtil.width : limite) / mockupWidth);
  } else {
    return (SizerUtil.width / mockupWidth);
  }
}

double get appBarSizeLandscape => device == DeviceType.mobile ? 2.5 : 2;

///Como estamos em modo paisagem (landscape), a largura se torna a altura, então a validação é baseada
///na altura quando o dispositivo está deitado. Geralmente, tablets têm uma altura maior que 400.
bool get isMobile => device == DeviceType.mobile && SizerUtil.width <= 430; 
