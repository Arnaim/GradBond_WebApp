import 'package:flutter/material.dart';

class AuthService {

  static final Map<String, String> _users = {}; 

  static Future<bool> signUp(String email, String password) async {
    if (_users.containsKey(email)) {
      return false; 
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