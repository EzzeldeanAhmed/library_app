import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';

enum AuthState { loading, authenticated, unauthenticated }

class AuthProvider with ChangeNotifier {
  User? _user;
  AuthState _authState = AuthState.loading;
  String? _errorMessage;

  User? get user => _user;
  AuthState get authState => _authState;
  bool get isLoggedIn => _authState == AuthState.authenticated;
  bool get isLoading => _authState == AuthState.loading;
  String? get errorMessage => _errorMessage;

  Future<void> initializeAuth() async {
    _authState = AuthState.loading;
    notifyListeners();

    // Simulate splash screen delay
    await Future.delayed(const Duration(seconds: 3));

    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user_data');
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

    if (isLoggedIn && userData != null) {
      try {
        _user = User.fromJson(json.decode(userData));
        _authState = AuthState.authenticated;
      } catch (e) {
        _authState = AuthState.unauthenticated;
        await prefs.clear();
      }
    } else {
      _authState = AuthState.unauthenticated;
    }

    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _errorMessage = null;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // Simple validation
    if (email.isEmpty || password.isEmpty) {
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

    // Simulate successful login
    _user = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: email.split('@')[0].toUpperCase(),
      email: email,
      phone: '+1234567890',
      address: '123 Main Street, City, Country',
    );

    _authState = AuthState.authenticated;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', true);
    await prefs.setString('user_data', json.encode(_user!.toJson()));

    notifyListeners();
    return true;
  }

  Future<bool> register(String name, String email, String password,
      String confirmPassword) async {
    _errorMessage = null;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

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

    // Simulate successful registration
    _user = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
    );

    _authState = AuthState.authenticated;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', true);
    await prefs.setString('user_data', json.encode(_user!.toJson()));

    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _user = null;
    _authState = AuthState.unauthenticated;
    _errorMessage = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    notifyListeners();
  }

  Future<void> updateProfile(String name, String phone, String address) async {
    if (_user != null) {
      _user!.name = name;
      _user!.phone = phone;
      _user!.address = address;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', json.encode(_user!.toJson()));

      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
