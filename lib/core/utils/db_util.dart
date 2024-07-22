class DBUtil {
  static const String dbName = 'expense_manager.db';
  static const String transactionTable = 'transactions_table';

  static const String createTableQuery = '''
    CREATE TABLE $transactionTable (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title VARCHAR(100),
      value REAL,
      date DATETIME
    )
  ''';
}