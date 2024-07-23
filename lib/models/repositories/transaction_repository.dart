import 'package:bet_manager_app/core/utils/db_util.dart';
import 'package:bet_manager_app/models/repositories/db_repository.dart';
import 'package:bet_manager_app/models/transaction.dart';
import 'package:sqflite/sqflite.dart' as sql_flite;

class TransactionRepository {
  final DBRepostiory _dbRepository = DBRepostiory();
  final List<Transaction> transactionsList = List<Transaction>.empty(growable: true);

  Future<List<Transaction>> getTransactions() async {
    final sql_flite.Database db = await _dbRepository.getDatabase();

    await db.rawQuery('SELECT * FROM ${DBUtil.transactionTable}').then((data) {
      transactionsList.addAll(
        data.map((e) => Transaction.fromJson(e)).toList()
      );
    });

    return transactionsList;
  }

    Future<List<Transaction>> saveTransaction(Transaction newTransaction) async {
    final sql_flite.Database db = await _dbRepository.getDatabase();

    final int transactionId = await db.rawInsert(
      'INSERT INTO ${DBUtil.transactionTable} (code, amount, type, date) VALUES (?, ?, ?, ?)',
      [newTransaction.code, newTransaction.amount, newTransaction.type.name, newTransaction.date.toIso8601String()],
    );
    transactionsList.add(newTransaction.copyWith(code: transactionId));

    return transactionsList;
  }

  Future<List<Transaction>> deleteTransaction({required int code}) async {
    final sql_flite.Database db = await _dbRepository.getDatabase();

    await db.rawDelete('DELETE FROM ${DBUtil.transactionTable} WHERE code = ?', [code]);
    transactionsList.removeWhere((transaction) => transaction.code == code);

    return transactionsList;
  }
}
