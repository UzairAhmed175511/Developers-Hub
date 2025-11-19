import 'package:flutter/material.dart';
import '../services/firebase_user_service.dart';
import '../models/user_model.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseUserService _userService = FirebaseUserService();

  UserModel? _user;
  UserModel? get user => _user;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  AuthViewModel() {
    // Listen to auth changes
    _userService.user.listen((userModel) {
      _user = userModel;
      notifyListeners();
    });
  }

  // ====================
  // Email/Password Auth
  // ====================
  Future<bool> signUp(String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await _userService.signUp(email, password);
      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await _userService.login(email, password);
      _loading = false;
      notifyListeners();
      return true; // Login successful
    } catch (e) {
      _error = e.toString();
      _loading = false;
      notifyListeners();
      return false; // Login failed
    }
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await _userService.sendPasswordResetEmail(email);
      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  // ====================
  // Logout
  // ====================
  Future<void> logout() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await _userService.logout();
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }
}
