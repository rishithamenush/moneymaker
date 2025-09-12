class AppConstants {
  // App Information
  static const String appName = 'Money Maker';
  static const String appVersion = '1.0.0';
  
  // Database
  static const String databaseName = 'money_maker.db';
  static const int databaseVersion = 1;
  
  // Storage Keys
  static const String themeKey = 'theme_mode';
  static const String userKey = 'user_data';
  static const String budgetKey = 'budget_data';
  
  // Default Values
  static const double defaultBudgetAmount = 50000.0; // LKR 50,000
  static const int defaultCurrencyDecimal = 0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
}
