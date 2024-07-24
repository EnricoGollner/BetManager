import 'package:bet_manager_app/core/utils/validator.dart';
import 'package:bet_manager_app/models/repositories/transaction_repository.dart';
import 'package:bet_manager_app/models/transaction.dart';
import 'package:bet_manager_app/models/week_day_expansion.dart';
import 'package:flutter/material.dart';

class TransactionController extends ChangeNotifier {
  late TransactionRepository _repository;

  List<Transaction> transactions = List.empty(growable: true);
  List<WeekDayExpansion> weekTransactions = List.empty(growable: true);

  TransactionController() {
    _repository = TransactionRepository();
  }

  Future<void> getTransactions() async {
    transactions = await _repository.getTransactions();
    orderRecentTransactions();
  }

  ///Método para ordenar transações da semana
  void orderRecentTransactions() {
    final DateTime currentDate = DateTime.now();
    DateTime firstWeekDay = currentDate.subtract(Duration(days: currentDate.weekday));  //Sunday
    
    weekTransactions = List.generate(
      7,
      (index) {
        final DateTime currentDate = firstWeekDay.add(Duration(days: index));
        return WeekDayExpansion(
          date: currentDate,
          transactions: transactions.where((transaction) => Validator.verifyDate(transaction.date, compareTo: currentDate)).toList(),
          isExpanded: false,
        );
      },
    );
    notifyListeners();
  }

  Future<void> addTransaction({required double amount, required TransactionType type}) async {
    final Transaction newTransaction = Transaction(
      amount: amount,
      type: type,
      date: DateTime.now(),
    );
    transactions = await _repository.saveTransaction(newTransaction);
    orderRecentTransactions();
  }

  Future<void> deleteTransaction(int code) async {
    transactions = await _repository.deleteTransaction(code: code);
    orderRecentTransactions();
  }
}