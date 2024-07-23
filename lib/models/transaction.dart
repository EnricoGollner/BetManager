import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  final int? code;
  final double amount;
  final TransactionType type;
  final DateTime date;

  const Transaction({this.code, required this.amount, required this.type, required this.date});

  @override
  List<Object?> get props => [code, amount, type, date];

  Transaction copyWith({
    int? code,
    double? amount,
    TransactionType? type,
    DateTime? date,
  }) {
    return Transaction(
      code: code ?? this.code,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      date: date ?? this.date,
    );
  }

  factory Transaction.fromJson(Map<String, dynamic> map) {
    return Transaction(
      code: map['code'] as int,
      amount: map['amount'] as double,
      type: TransactionType.values.byName(map['type']),
      date: DateTime.parse(map['date']),
    );
  }
}

enum TransactionType {
  deposit,
  income,
}
