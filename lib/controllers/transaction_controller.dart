import 'package:bet_manager_app/models/repositories/transaction_repository.dart';
import 'package:bet_manager_app/models/transaction.dart';
import 'package:flutter/material.dart';

class TransactionController extends ChangeNotifier {
  late TransactionRepository _repository;

  List<Transaction> transactions = List.empty(growable: true);
  List<Transaction> weekTransactions = List.empty(growable: true);

  TransactionController() {
    _repository = TransactionRepository();
  }

  Future<void> getTransactions() async {
    transactions = await _repository.getTransactions();
    orderRecentTransactions();
  }

  ///Método para ordenar transações da semana
  void orderRecentTransactions() {
    weekTransactions = transactions.where(
      (transaction) => transaction.date.isAfter(DateTime.now().subtract(const Duration(days: 7))),
    ).toList();
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