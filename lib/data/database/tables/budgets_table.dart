class BudgetsTable {
  static const String tableName = 'budgets';
  
  static const String createTable = '''
    CREATE TABLE $tableName (
      id TEXT PRIMARY KEY,
      amount REAL NOT NULL,
      category_id TEXT NOT NULL,
      category_name TEXT NOT NULL,
      month TEXT NOT NULL,
      spent_amount REAL NOT NULL DEFAULT 0,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (category_id) REFERENCES categories (id)
    )
  ''';
  
  static const String id = 'id';
  static const String amount = 'amount';
  static const String categoryId = 'category_id';
  static const String categoryName = 'category_name';
  static const String month = 'month';
  static const String spentAmount = 'spent_amount';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}
