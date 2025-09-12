import 'database_helper.dart';
import 'data_seeder.dart';

class DatabaseService {
  static bool _isInitialized = false;
  
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Initialize the database
      await DatabaseHelper.database;
      
      // Seed initial data
      await DataSeeder.seedInitialData();
      
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
