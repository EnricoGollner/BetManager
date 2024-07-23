import 'package:bet_manager_app/models/transaction.dart';
import 'package:flutter/material.dart';

class TransactionController extends ChangeNotifier {
  List<Transaction> transactions = List.empty(growable: true);
  List<Transaction> weekTransactions = List.empty(growable: true);

  TransactionController();

  void getRecentTransactions() {
    final List<Transaction> recentTransactions = transactions.where(
          (transaction) => transaction.date.isAfter(DateTime.now().subtract(const Duration(days: 7))),
        ).toList();

    weekTransactions = recentTransactions;
    notifyListeners();
  }

  void addTransaction({required double value, required TransactionType type}) {
    final Transaction newTransaction = Transaction(
      code: 1,
      amount: value,
      type: type,
      // date: DateTime.now(), //TODO - DESCOMENTAR
      date: DateTime(2024, 7, 28),  //TESTE DE REGISTRO DIA DA SEMANA
    );
    transactions.add(newTransaction);
    
    getRecentTransactions();
  }

  void deleteTransaction(int code) {
    transactions.removeWhere((entry) => entry.code == code);
    getRecentTransactions();
  }
}