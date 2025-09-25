import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../domain/entities/user_auth.dart';

class AuthProvider extends ChangeNotifier {
  FirebaseAuth? _auth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  UserAuth? _user;
  bool _isLoading = false;
  String? _error;
  bool _firebaseAvailable = false;
  
  // Store user names temporarily
  final Map<String, String> _userNames = {};

  UserAuth? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;
  bool get firebaseAvailable => _firebaseAvailable;
  bool get isLoggedIn => (_auth?.currentUser != null) || _user != null;

  AuthProvider() {
    _initializeFirebase();
  }

  void _initializeFirebase() {
    try {
      _auth = FirebaseAuth.instance;
      _auth!.authStateChanges().listen(_onAuthStateChanged);
      _firebaseAvailable = true;
      print('Firebase Auth initialized successfully');
    } catch (e) {
      print('Firebase Auth not available: $e');
      _firebaseAvailable = false;
      _auth = null;
      // Continue without Firebase Auth
    }
  }

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

    if (!_firebaseAvailable || _auth == null) {
      _setError('Authentication service not available. Please try again later.');
      _setLoading(false);
      return false;
    }

    try {
      print('Starting login for: $email');
      final UserCredential result = await _auth!.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('Login result: ${result.user?.uid}');

      if (result.user != null) {
        // Wait a bit for auth state to update
        await Future.delayed(const Duration(milliseconds: 500));
        
        print('Login successful for: ${result.user!.email}');
        _setLoading(false);
        return true;
      } else {
        print('Login failed: User is null');
        _setError('Login failed. Please try again.');
        _setLoading(false);
        return false;
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Login failed. Please try again.';
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email address.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address.';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many failed attempts. Please try again later.';
          break;
      }
      _setError(errorMessage);
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('Login failed. Please try again.');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _setLoading(true);
    _setError(null);

    if (!_firebaseAvailable || _auth == null) {
      _setError('Authentication service not available. Please try again later.');
      _setLoading(false);
      return false;
    }

    try {
      print('Starting registration for: $email');
      final UserCredential result = await _auth!.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('User creation result: ${result.user?.uid}');

      if (result.user != null) {
        print('User created successfully: ${result.user!.email}');
        
        // Store the name locally to use in auth state change
        if (result.user!.email != null) {
          _userNames[result.user!.email!] = name;
        }
        
        // Wait a bit for auth state to update
        await Future.delayed(const Duration(milliseconds: 500));
        
        print('Registration successful for: ${result.user!.email}');
        _setLoading(false);
        return true;
      } else {
        print('Registration failed: User is null');
        _setError('Registration failed. Please try again.');
        _setLoading(false);
        return false;
      }
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.code} - ${e.message}');
      String errorMessage = 'Registration failed. Please try again.';
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'Password is too weak.';
          break;
        case 'email-already-in-use':
          errorMessage = 'An account already exists with this email address.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email/password accounts are not enabled.';
          break;
      }
      _setError(errorMessage);
      _setLoading(false);
      return false;
    } catch (e) {
      print('General exception during registration: $e');
      _setError('Registration failed. Please try again.');
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    
    try {
      if (_firebaseAvailable && _auth != null) {
        await _auth!.signOut();
      }
      await _googleSignIn.signOut();
      _setUser(null);
      _setError(null);
    } catch (e) {
      _setError('Logout failed. Please try again.');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _setError(null);

    if (!_firebaseAvailable || _auth == null) {
      _setError('Authentication service not available. Please try again later.');
      _setLoading(false);
      return false;
    }

    try {
      await _auth!.sendPasswordResetEmail(email: email);
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Password reset failed. Please try again.';
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email address.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many requests. Please try again later.';
          break;
      }
      _setError(errorMessage);
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('Password reset failed. Please try again.');
      _setLoading(false);
      return false;
    }
  }

  void _onAuthStateChanged(User? firebaseUser) {
    print('Auth state changed: ${firebaseUser?.uid ?? 'null'}');
    if (firebaseUser != null) {
      print('Setting user: ${firebaseUser.email} (${firebaseUser.uid})');
      
      // Get name from stored names, displayName, or generate from email
      String userName = '';
      if (firebaseUser.email != null && _userNames.containsKey(firebaseUser.email!)) {
        userName = _userNames[firebaseUser.email!]!;
        print('Using stored name: $userName');
      } else if (firebaseUser.displayName?.isNotEmpty == true) {
        userName = firebaseUser.displayName!;
        print('Using Firebase displayName: $userName');
      } else {
        userName = _getNameFromEmail(firebaseUser.email ?? '');
        print('Generated name from email: $userName');
      }
      
      _user = UserAuth(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        name: userName,
        profileImage: firebaseUser.photoURL,
        createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
        lastLoginAt: firebaseUser.metadata.lastSignInTime ?? DateTime.now(),
        isEmailVerified: firebaseUser.emailVerified,
      );
      print('User set successfully: ${_user?.email} with name: ${_user?.name}');
    } else {
      print('Clearing user');
      _user = null;
    }
    notifyListeners();
  }

  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    _setError(null);

    if (!_firebaseAvailable || _auth == null) {
      _setError('Authentication service not available. Please try again later.');
      _setLoading(false);
      return false;
    }

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _setLoading(false);
        return false;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth!.signInWithCredential(credential);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Google Sign-In failed. Please try again.');
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
