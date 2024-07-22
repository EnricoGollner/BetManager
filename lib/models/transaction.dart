import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  final int code;
  final double amount;
  final TransactionType type;
  final DateTime date;

  const Transaction({required this.code, required this.amount, required this.type, required this.date});

  @override
  List<Object?> get props => [code, amount, type, date];
}

enum TransactionType {
  deposit,
  income,
}