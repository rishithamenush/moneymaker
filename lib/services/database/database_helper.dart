import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../data/database/tables/categories_table.dart';
import '../../data/database/tables/expenses_table.dart';
import '../../data/database/tables/budgets_table.dart';
import '../../data/database/tables/incomes_table.dart';

class DatabaseHelper {
  static const String _databaseName = 'moneymaker.db';
  static const int _databaseVersion = 1;
  
  static Database? _database;
  
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  
  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }
  
  static Future<void> _onCreate(Database db, int version) async {
    // Create categories table
    await db.execute(CategoriesTable.createTable);
    
    // Create expenses table
    await db.execute(ExpensesTable.createTable);
    
    // Create budgets table
    await db.execute(BudgetsTable.createTable);
    
    // Create incomes table
    await db.execute(IncomesTable.createTableQuery);
    
    // Insert default categories
    await _insertDefaultCategories(db);
  }
  
  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
    if (oldVersion < 2) {
      // Example: Add new columns or tables for version 2
    }
  }
  
  static Future<void> _insertDefaultCategories(Database db) async {
    final defaultCategories = [
      {
        'id': 'food',
        'name': 'Food & Dining',
        'color_value': 0xFF4CAF50,
        'icon_name': 'restaurant',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      {
        'id': 'transport',
        'name': 'Auto & Transport',
        'color_value': 0xFF2196F3,
        'icon_name': 'directions_car',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      {
        'id': 'bills',
        'name': 'Bills & Utilities',
        'color_value': 0xFFFF9800,
        'icon_name': 'receipt',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      {
        'id': 'shopping',
        'name': 'Shopping',
        'color_value': 0xFF9C27B0,
        'icon_name': 'shopping_bag',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      {
        'id': 'entertainment',
        'name': 'Entertainment',
        'color_value': 0xFFE91E63,
        'icon_name': 'movie',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      {
        'id': 'health',
        'name': 'Health & Fitness',
        'color_value': 0xFF00BCD4,
        'icon_name': 'favorite',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      {
        'id': 'education',
        'name': 'Education',
        'color_value': 0xFF795548,
        'icon_name': 'school',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      {
        'id': 'other',
        'name': 'Other',
        'color_value': 0xFF607D8B,
        'icon_name': 'more_horiz',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
    ];
    
    for (final category in defaultCategories) {
      await db.insert(CategoriesTable.tableName, category);
    }
  }
  
  static Future<void> close() async {
    final db = await database;
    await db.close();
  }
  
  static Future<void> clearAllData() async {
    final db = await database;
    await db.delete(ExpensesTable.tableName);
    await db.delete(BudgetsTable.tableName);
    await db.delete(CategoriesTable.tableName);
    await _insertDefaultCategories(db);
  }
}