import 'package:flutter/material.dart';

class AuthService {
  // In a real app, you would use Firebase Auth or your backend
  // For demo purposes, we'll use simple in-memory storage
  static final Map<String, String> _users = {}; // email: password

  static Future<bool> signUp(String email, String password) async {
    if (_users.containsKey(email)) {
      return false; // User already exists
    }
    _users[email] = password;
    return true;
  }

  static Future<bool> login(String email, String password) async {
    return _users[email] == password;
  }

  static void showAuthError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}