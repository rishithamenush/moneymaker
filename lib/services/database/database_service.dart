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
      
      // Clear all existing data for fresh start
      await clearAllData();
      
      // Seed initial data (now disabled)
      await DataSeeder.seedInitialData();
      
      _isInitialized = true;
      print('Database initialized successfully with fresh data');
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
