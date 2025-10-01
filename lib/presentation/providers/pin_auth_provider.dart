import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinAuthProvider extends ChangeNotifier {
  static const String _pinKey = 'user_pin';
  static const String _isEnabledKey = 'pin_auth_enabled';
  
  bool _isEnabled = false;
  String? _storedPin;
  bool _isInitialized = false;

  bool get isEnabled => _isEnabled;
  String? get storedPin => _storedPin;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      _isEnabled = prefs.getBool(_isEnabledKey) ?? false;
      _storedPin = prefs.getString(_pinKey);
      _isInitialized = true;
      
      print('PIN Auth initialized - Enabled: $_isEnabled, PIN: ${_storedPin != null ? "***" : "null"}');
      notifyListeners();
    } catch (e) {
      print('Error initializing PIN auth: $e');
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<bool> setPin(String pin) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_pinKey, pin);
      _storedPin = pin;
      notifyListeners();
      return true;
    } catch (e) {
      print('Error setting PIN: $e');
      return false;
    }
  }

  Future<bool> enablePinAuth(String pin) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_pinKey, pin);
      await prefs.setBool(_isEnabledKey, true);
      _storedPin = pin;
      _isEnabled = true;
      
      print('PIN Auth enabled - PIN saved: ***, Enabled: $_isEnabled');
      notifyListeners();
      return true;
    } catch (e) {
      print('Error enabling PIN auth: $e');
      return false;
    }
  }

  Future<bool> disablePinAuth(String pin) async {
    if (_storedPin != pin) {
      return false; // Wrong PIN
    }
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_pinKey);
      await prefs.setBool(_isEnabledKey, false);
      _storedPin = null;
      _isEnabled = false;
      
      print('PIN Auth disabled - PIN removed, Enabled: $_isEnabled');
      notifyListeners();
      return true;
    } catch (e) {
      print('Error disabling PIN auth: $e');
      return false;
    }
  }

  bool verifyPin(String pin) {
    return _storedPin == pin;
  }

  Future<bool> changePin(String currentPin, String newPin) async {
    if (_storedPin != currentPin) {
      return false; // Wrong current PIN
    }
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_pinKey, newPin);
      _storedPin = newPin;
      notifyListeners();
      return true;
    } catch (e) {
      print('Error changing PIN: $e');
      return false;
    }
  }

  void clearError() {
    // This method is kept for consistency with other providers
    // but PIN auth doesn't have persistent error states
  }
}
