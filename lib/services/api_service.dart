import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:gradbond/models/event_model.dart';
import 'dart:html' as html; // Only works on web

class ApiService {
  static const String baseUrl = 'https://gradbond.vercel.app/api';

  static Future<List<Event>> fetchEvents() async {
    try {
      print('Fetching events from: $baseUrl/events/');
      final response = await http.get(
        Uri.parse('$baseUrl/events/'),
        headers: {'Accept': 'application/json'},
      );

      print('API Response Status: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> eventsJson = data['events'] as List;
        return eventsJson.map((json) => Event.fromJson(json)).toList();
      } else {
        throw Exception("HTTP ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      print('Error in fetchEvents: $e');
      throw Exception('Failed to fetch events: ${e.toString()}');
    }
  }
}

class StorageService {
  static Future<void> saveToken(String token) async {
    if (kIsWeb) {
      html.window.localStorage['auth_token'] = token;
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
    }
  }

  static Future<String?> getToken() async {
    if (kIsWeb) {
      return html.window.localStorage['auth_token'];
    } else {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('auth_token');
    }
  }

  static Future<void> clearToken() async {
    if (kIsWeb) {
      html.window.localStorage.remove('auth_token');
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
    }
  }
}

class AuthService {
  static const String loginUrl = 'https://gradbond.vercel.app/api/login/';
  static const String logoutUrl = 'https://gradbond.vercel.app/api/logout/';
  static const String signupUrl = 'https://gradbond.vercel.app/api/signup/';

static Future<bool> login(String email, String password) async {
  try {
    final response = await http.post(
      Uri.parse(loginUrl),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'email': email.trim(),
        'password': password,
      }),
    );

    print('Login Response: ${response.statusCode} - ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 200 && data['token'] is String) {
        await StorageService.saveToken(data['token']);
        print('Login successful! Token saved.');
        return true;
      }
      // Check if cookies are being set
      print('Response headers: ${response.headers}');
    }

    print('Login failed. Status: ${response.statusCode}');
    return false;
  } catch (e) {
    print('Login error: $e');
    return false;
  }
}

  static Future<bool> isLoggedIn() async {
    final token = await StorageService.getToken();
    return token != null;
  }

  static Future<bool> logout(BuildContext context) async {
    try {
      final token = await StorageService.getToken();

      if (token == null) {
        return true; // Already logged out
      }

      // Optional: Call backend logout if needed
      /*
      final response = await http.get(
        Uri.parse(logoutUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      print('Logout Response: ${response.statusCode} - ${response.body}');
      */

      await StorageService.clearToken();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged out successfully')),
      );

      return true;
    } catch (e) {
      showAuthError(context, 'An error occurred during logout.');
      return false;
    }
  }

static Future<bool> signup(String userType, String email, String password) async {
  try {
    print('Sending userType: $userType');
    await StorageService.clearToken();
    final response = await http.post(
      Uri.parse(signupUrl),
      body: jsonEncode({
        'userType': userType,
        'email': email.trim(),
        'pass1': password,
        'pass2': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    print('Signup Response: ${response.statusCode} - ${response.body}');
    
    // Consider 200 status as success even without token
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // If token exists, save it (for APIs that auto-login)
      if (data['token'] != null) {
        await StorageService.saveToken(data['token']);
      }
      return true; // Success if status is 200
    }
    return false;
  } catch (e) {
    print('Signup error: $e');
    return false;
  }
}




  static void showAuthError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
