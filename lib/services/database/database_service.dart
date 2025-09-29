import 'database_helper.dart';
import 'data_seeder.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static bool _isInitialized = false;
  
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Initialize the database
      await DatabaseHelper.database;
      
      _isInitialized = true;
      print('Database initialized successfully');
    } catch (e) {
      print('Error initializing database: $e');
      rethrow;
    }
  }

  
  static Future<void> clearAllData() async {
    await DatabaseHelper.clearAllData();
  }
  
  static Future<void> close() async {
    await DatabaseHelper.close();
    _isInitialized = false;
  }
}
