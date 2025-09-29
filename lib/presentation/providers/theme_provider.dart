import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  String _accentColor = 'Orange';
  bool _isInitialized = false;

  ThemeMode get themeMode => _themeMode;
  String get accentColor => _accentColor;
  bool get isInitialized => _isInitialized;

  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  // Initialize theme settings from storage
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load theme mode
      final themeModeIndex = prefs.getInt('theme_mode') ?? 0;
      _themeMode = ThemeMode.values[themeModeIndex];
      
      // Load accent color
      _accentColor = prefs.getString('accent_color') ?? 'Orange';
      
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      // If loading fails, use defaults
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('theme_mode', mode.index);
    } catch (e) {
      // Handle storage error silently
    }
  }

  Future<void> setAccentColor(String colorName) async {
    _accentColor = colorName;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accent_color', colorName);
    } catch (e) {
      // Handle storage error silently
    }
  }

  Future<void> toggleTheme() async {
    final newMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await setThemeMode(newMode);
  }
}
