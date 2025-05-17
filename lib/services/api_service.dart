import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:gradbond/models/event_model.dart';

class ApiService {
  static const String baseUrl = 'https://gradbond.vercel.app/api';

  static Future<List<Event>> fetchEvents() async {
    try {
      print('Fetching events from: $baseUrl/events/'); // Debug
      final response = await http.get(
        Uri.parse('$baseUrl/events/'),
        headers: {'Accept': 'application/json'},
      );

      print('API Response Status: ${response.statusCode}'); // Debug
      print('API Response Body: ${response.body}'); // Debug

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        
        // Debug: Print the decoded data structure
        print('Decoded Data Type: ${data.runtimeType}');
        print('Decoded Data Keys: ${data.keys}');

        // Extract the 'events' list
        final List<dynamic> eventsJson = data['events'] as List; // Explicit cast
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


class AuthService {
  static const String loginUrl = 'https://gradbond.vercel.app/api/login/';

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

    print('API Response: ${response.statusCode} - ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
      // Check both HTTP 200 AND JSON status 200
      if (data['status'] == 200 && data['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', data['token']);
        print('Login successful! Token saved.');
        return true;
      }
    }
    
    print('Login failed. Status: ${response.statusCode}');
    return false;
  } catch (e) {
    print('Login error: $e');
    return false;
  }
}
static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') != null;
  }

  // logout method
static Future<bool> logout(BuildContext context) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token'); // Changed from authToken to auth_token
    
    if (token == null) {
      // No token found, consider user already logged out
      return true;
    }

    final response = await http.get(
      Uri.parse('https://gradbond.vercel.app/api/logout/'), // Using full URL for consistency
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json', // Added Accept header
      },
    );

    print('Logout Response: ${response.statusCode} - ${response.body}');

    final responseData = jsonDecode(response.body);
    
    if (response.statusCode == 200 && responseData['status'] == 200) {
      // Clear stored credentials
      await prefs.remove('auth_token');
      await prefs.remove('userData');
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged out successfully')),
      );
      
      return true;
    } else {
      // Handle logout error
      final errorMessage = responseData['message'] ?? 'Logout failed. Please try again.';
      showAuthError(context, errorMessage);
      return false;
    }
  } catch (e) {
    showAuthError(context, 'An error occurred during logout.');
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

