/// App constants that should match pubspec.yaml
/// 
/// IMPORTANT: When you update the version in pubspec.yaml, 
/// make sure to update the values here as well!
/// 
/// Example: If pubspec.yaml has "version: 1.0.12+68"
/// Then: appVersion = '1.0.12' and buildNumber = '68'
class AppConstants {
  // App Information
  static const String appName = 'MoneyMaker';
  static const String appVersion = '1.0.12'; // Should match version in pubspec.yaml
  static const String buildNumber = '68'; // Should match build number in pubspec.yaml
  
  /// Full version string (e.g., "1.0.12 (68)")
  static String get fullVersion => '$appVersion ($buildNumber)';
  
  /// Version with build number (e.g., "1.0.12+68")
  static String get versionWithBuild => '$appVersion+$buildNumber';
  
  // Package Information
  static const String packageName = 'com.example.moneymaker';
  
  // App Description
  static const String appDescription = 'A simple and elegant money management app to help you track your income and expenses.';
}