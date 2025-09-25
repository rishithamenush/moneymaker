class CategoriesTable {
  static const String tableName = 'categories';
  
  static const String createTable = '''
    CREATE TABLE $tableName (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      color_value INTEGER NOT NULL,
      icon_name TEXT NOT NULL,
      is_default INTEGER NOT NULL DEFAULT 0,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL
    )
  ''';
  
  static const String id = 'id';
  static const String name = 'name';
  static const String colorValue = 'color_value';
  static const String iconName = 'icon_name';
  static const String isDefault = 'is_default';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}
