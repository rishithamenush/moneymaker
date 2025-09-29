import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'selected_language';
  
  Locale _locale = const Locale('en', '');
  bool _isInitialized = false;
  
  // Supported languages
  static const List<Locale> supportedLocales = [
    Locale('en', ''), // English
    Locale('es', ''), // Spanish
    Locale('fr', ''), // French
    Locale('de', ''), // German
    Locale('zh', ''), // Chinese
    Locale('ja', ''), // Japanese
    Locale('si', ''), // Sinhala
  ];
  
  // Language names for display
  static const Map<String, String> languageNames = {
    'en': 'English',
    'es': 'Español',
    'fr': 'Français',
    'de': 'Deutsch',
    'zh': '中文',
    'ja': '日本語',
    'si': 'සිංහල',
  };
  
  Locale get locale => _locale;
  bool get isInitialized => _isInitialized;
  
  String get currentLanguageCode => _locale.languageCode;
  String get currentLanguageName => languageNames[_locale.languageCode] ?? 'English';
  
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguageCode = prefs.getString(_languageKey);
      
      if (savedLanguageCode != null) {
        _locale = Locale(savedLanguageCode);
      } else {
        // Default to system locale if supported, otherwise English
        final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
        if (supportedLocales.any((locale) => locale.languageCode == systemLocale.languageCode)) {
          _locale = Locale(systemLocale.languageCode);
        } else {
          _locale = const Locale('en');
        }
      }
      
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      // Fallback to English if initialization fails
      _locale = const Locale('en');
      _isInitialized = true;
      notifyListeners();
    }
  }
  
  Future<void> setLanguage(String languageCode) async {
    if (!supportedLocales.any((locale) => locale.languageCode == languageCode)) {
      return;
    }
    
    _locale = Locale(languageCode);
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);
    } catch (e) {
      // Handle error silently
    }
  }
  
  static String getLanguageName(String languageCode) {
    return languageNames[languageCode] ?? 'English';
  }
}
