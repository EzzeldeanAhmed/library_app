import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart' as app_models;
import '../services/firebase_auth_service.dart';

enum AuthState { loading, authenticated, unauthenticated }

class AuthProvider with ChangeNotifier {
  final FirebaseAuthService _authService = FirebaseAuthService();

  app_models.User? _user;
  AuthState _authState = AuthState.loading;
  String? _errorMessage;

  app_models.User? get user => _user;
  AuthState get authState => _authState;
  bool get isLoggedIn => _authState == AuthState.authenticated;
  bool get isLoading => _authState == AuthState.loading;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _initializeAuth();
  }

  void _initializeAuth() {
    // Listen to auth state changes
    _authService.authStateChanges.listen((User? firebaseUser) async {
      if (firebaseUser != null) {
        try {
          // Get user data from Firestore
          _user = await _authService.getUserData(firebaseUser.uid);
          _authState = AuthState.authenticated;
        } catch (e) {
          print('Error getting user data: $e');
          _authState = AuthState.unauthenticated;
          _user = null;
        }
      } else {
        _user = null;
        _authState = AuthState.unauthenticated;
      }
      notifyListeners();
    });
  }

  Future<void> initializeAuth() async {
    _authState = AuthState.loading;
    notifyListeners();

    // Add splash screen delay
    await Future.delayed(const Duration(seconds: 3));

    // Check if user is already signed in
    if (_authService.currentUser != null) {
      try {
        _user = await _authService.getUserData(_authService.currentUser!.uid);
        _authState = AuthState.authenticated;
      } catch (e) {
        _authState = AuthState.unauthenticated;
        _user = null;
      }
    } else {
      _authState = AuthState.unauthenticated;
    }

    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (_user != null) {
        _authState = AuthState.authenticated;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Login failed. Please try again.';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password,
      String confirmPassword) async {
    _errorMessage = null;
    notifyListeners();

    // Validation
    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _errorMessage = 'Please fill all fields';
      notifyListeners();
      return false;
    }

    if (!email.contains('@')) {
      _errorMessage = 'Please enter a valid email';
      notifyListeners();
      return false;
    }

    if (password.length < 6) {
      _errorMessage = 'Password must be at least 6 characters';
      notifyListeners();
      return false;
    }

    if (password != confirmPassword) {
      _errorMessage = 'Passwords do not match';
      notifyListeners();
      return false;
    }

    try {
      _user = await _authService.registerWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
      );

      if (_user != null) {
        _authState = AuthState.authenticated;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Registration failed. Please try again.';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _authService.signOut();
      _user = null;
      _authState = AuthState.unauthenticated;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to logout: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> updateProfile(String name, String phone, String address) async {
    if (_user != null) {
      try {
        _user!.name = name;
        _user!.phone = phone;
        _user!.address = address;

        await _authService.updateUserProfile(_user!);
        notifyListeners();
      } catch (e) {
        _errorMessage = 'Failed to update profile: ${e.toString()}';
        notifyListeners();
        rethrow;
      }
    }
  }

  Future<void> resetPassword(String email) async {
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.resetPassword(email);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      rethrow;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
