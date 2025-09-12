class CategoryTable {
  static const String tableName = 'categories';
  static const String columnId = 'id';
  static const String columnName = 'name';
  static const String columnIconPath = 'icon_path';
  static const String columnColorValue = 'color_value';
  static const String columnIsDefault = 'is_default';
  static const String columnCreatedAt = 'created_at';

  static const String createTable = '''
    CREATE TABLE $tableName (
      $columnId TEXT PRIMARY KEY,
      $columnName TEXT NOT NULL,
      $columnIconPath TEXT NOT NULL,
      $columnColorValue INTEGER NOT NULL,
      $columnIsDefault INTEGER NOT NULL DEFAULT 0,
      $columnCreatedAt TEXT NOT NULL
    )
  ''';
}
