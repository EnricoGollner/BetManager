class DBUtil {
  static const String dbName = 'expense_manager.db';
  static const String transactionTable = 'transactions_table';

  static const String createTableQuery = '''
    CREATE TABLE $transactionTable (
      code INTEGER PRIMARY KEY AUTOINCREMENT,
      amount REAL,
      type VARCHAR(30),
      date DATETIME
    )
  ''';
}