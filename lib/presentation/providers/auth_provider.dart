import 'package:flutter/foundation.dart';
import '../../domain/entities/user_auth.dart';

class AuthProvider extends ChangeNotifier {
  UserAuth? _user;
  bool _isLoading = false;
  String? _error;

  UserAuth? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void _setUser(UserAuth? user) {
    _user = user;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _setError(null);

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock authentication - in real app, this would call an API
      if (email.isNotEmpty && password.isNotEmpty) {
        final user = UserAuth(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          email: email,
          name: _getNameFromEmail(email),
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
          lastLoginAt: DateTime.now(),
          isEmailVerified: true,
        );

        _setUser(user);
        _setLoading(false);
        return true;
      } else {
        _setError('Please enter valid email and password');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Login failed. Please try again.');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _setLoading(true);
    _setError(null);

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock registration - in real app, this would call an API
      if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
        final user = UserAuth(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          email: email,
          name: name,
          createdAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
          isEmailVerified: false,
        );

        _setUser(user);
        _setLoading(false);
        return true;
      } else {
        _setError('Please fill in all fields');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Registration failed. Please try again.');
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    
    // Simulate logout delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    _setUser(null);
    _setError(null);
    _setLoading(false);
  }

  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _setError(null);

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      if (email.isNotEmpty) {
        _setLoading(false);
        return true;
      } else {
        _setError('Please enter a valid email address');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Password reset failed. Please try again.');
      _setLoading(false);
      return false;
    }
  }

  String _getNameFromEmail(String email) {
    final name = email.split('@')[0];
    return name.split('.').map((word) => 
      word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : ''
    ).join(' ');
  }

  void clearError() {
    _setError(null);
  }
}
