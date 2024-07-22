
import 'package:flutter/material.dart';

class FilterController extends ChangeNotifier {
  DateTime _initialDate = DateTime(2024);
  DateTime _finalDate = DateTime.now();

  DateTime get initialDate => _initialDate;
  DateTime get finalDate => _finalDate;

  void setInitialDate(DateTime value) => _initialDate = value;

  void setFinalDate(DateTime value) => _finalDate = value;

  void resetDateRange() {
    _initialDate = DateTime(2024);
    _finalDate = DateTime.now();
  }
}
