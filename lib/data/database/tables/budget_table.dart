class BudgetTable {
  static const String tableName = 'budgets';
  static const String columnId = 'id';
  static const String columnAmount = 'amount';
  static const String columnCategoryId = 'category_id';
  static const String columnCategoryName = 'category_name';
  static const String columnMonth = 'month';
  static const String columnSpentAmount = 'spent_amount';
  static const String columnCreatedAt = 'created_at';
  static const String columnUpdatedAt = 'updated_at';

  static const String createTable = '''
    CREATE TABLE $tableName (
      $columnId TEXT PRIMARY KEY,
      $columnAmount REAL NOT NULL,
      $columnCategoryId TEXT NOT NULL,
      $columnCategoryName TEXT NOT NULL,
      $columnMonth TEXT NOT NULL,
      $columnSpentAmount REAL NOT NULL DEFAULT 0,
      $columnCreatedAt TEXT NOT NULL,
      $columnUpdatedAt TEXT NOT NULL
    )
  ''';
}
