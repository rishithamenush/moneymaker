class ExpenseTable {
  static const String tableName = 'expenses';
  static const String columnId = 'id';
  static const String columnAmount = 'amount';
  static const String columnDescription = 'description';
  static const String columnCategoryId = 'category_id';
  static const String columnCategoryName = 'category_name';
  static const String columnDate = 'date';
  static const String columnCreatedAt = 'created_at';
  static const String columnUpdatedAt = 'updated_at';

  static const String createTable = '''
    CREATE TABLE $tableName (
      $columnId TEXT PRIMARY KEY,
      $columnAmount REAL NOT NULL,
      $columnDescription TEXT NOT NULL,
      $columnCategoryId TEXT NOT NULL,
      $columnCategoryName TEXT NOT NULL,
      $columnDate TEXT NOT NULL,
      $columnCreatedAt TEXT NOT NULL,
      $columnUpdatedAt TEXT NOT NULL
    )
  ''';
}
