import 'package:bet_manager_app/models/transaction.dart';

class WeekDayExpansion {
  final DateTime date;
  final List<Transaction> transactions;
  bool isExpanded;

  WeekDayExpansion({
    required this.date,
    required this.transactions,
    required this.isExpanded,
  });
}
