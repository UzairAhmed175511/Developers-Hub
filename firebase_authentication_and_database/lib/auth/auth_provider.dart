import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? user;

  AuthProvider() {
    user = _authService.currentUser;
    FirebaseAuth.instance.authStateChanges().listen((u) {
      user = u;
      notifyListeners();
    });
  }

  Future<void> login(String email, String password) async {
    await _authService.login(email: email, password: password);
  }

  Future<void> signUp(String name, String email, String password) async {
    await _authService.signUp(name: name, email: email, password: password);
  }

  Future<void> logout() async {
    await _authService.logout();
  }
}
