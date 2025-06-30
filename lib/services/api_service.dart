import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:gradbond/models/event_model.dart';
import 'package:gradbond/models/job_model.dart';
import 'package:gradbond/models/alumni_model.dart';
import 'package:gradbond/services/storage/storage_service.dart';

class ApiService {
  static const String baseUrl = 'https://gradbond.up.railway.app/api/';

  //  Find alumni based on filters
  static Future<List<Alumni>> findAlumni({
    String? university,
    String? department,
    String? company,
    String? jobTitle,
  }) async {
    try {
      final uri = Uri.parse('${baseUrl}find-alumni/').replace(queryParameters: {
        'university': university ?? '',
        'department': department ?? '',
        'company': company ?? '',
        'job_title': jobTitle ?? '',
      });

      final response = await http.get(uri, headers: {
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> alumniJson = data['alumni'];
        return alumniJson.map((json) => Alumni.fromJson(json)).toList();
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print("Error in findAlumni: $e");
      rethrow;
    }
  }

  //  Fetch alumni to display on home page (filtered)
  static Future<List<Alumni>> fetchAlumniForHome() async {
    final uri = Uri.parse('${baseUrl}find-alumni/').replace(queryParameters: {
      'university': 'BUBT', // Example query for home
    });

    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
      },
    );

    print(' Alumni Fetch Response: ${response.statusCode}');
    print(' Alumni Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> alumniList = data['alumni'];
      return alumniList.map((json) => Alumni.fromJson(json)).toList();
    } else {
      throw Exception("Alumni fetch failed: ${response.body}");
    }
  }

  // 👤 Get current logged-in user's profile using token
  static Future<Map<String, dynamic>?> fetchMyProfile() async {
    final token = await StorageService.getToken();
    print(" Token: $token");

    if (token == null) return null;

    try {
      final response = await http.get(
        Uri.parse('${baseUrl}profile/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print(' Profile API Response Code: ${response.statusCode}');
      print(' Profile API Body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print(" Error in fetchMyProfile: $e");
      return null;
    }
  }

  //  Get all events
  static Future<List<Event>> fetchEvents() async {
    final response = await http.get(Uri.parse('$baseUrl/events/'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data['status'] != 200) {
        throw Exception('API returned status ${data['status']}');
      }

      final List<dynamic> eventsJson = data['events'];
      final events = eventsJson.map((json) => Event.fromJson(json)).toList();

      print("DEBUG: Fetched ${events.length} events");
      for (var e in events) {
        print("DEBUG Event: ${e.name}, ${e.date}, ${e.imageUrl}");
      }

      return events;
    } else {
      throw Exception('HTTP error: ${response.statusCode}');
    }
  }

  //  Get all job listings
  static Future<List<Job>> fetchJobs() async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}jobs/'),
        headers: {'Accept': 'application/json'},
      );

      print('Jobs API Response: ${response.statusCode}');
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['jobs'] is List) {
        return (data['jobs'] as List)
            .map((json) => Job.fromJson(json))
            .toList();
      } else {
        throw Exception('Unexpected JSON structure');
      }
    } catch (e) {
      print('Error fetching jobs: $e');
      throw Exception('Failed to fetch jobs: $e');
    }
  }
}

class AuthService {
  static const String loginUrl = 'https://gradbond.up.railway.app/api/login/';
  static const String logoutUrl = 'https://gradbond.up.railway.app/api/logout/';
  static const String signupUrl = 'https://gradbond.up.railway.app/api/signup/';

  //  Login function
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
          await StorageService.saveToken(data['token']); // Save token locally
          print('Login successful! Token saved.');
          return true;
        }
        print('Response headers: ${response.headers}');
      }

      print('Login failed. Status: ${response.statusCode}');
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  //  Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await StorageService.getToken();
    return token != null;
  }

  //  Logout user
  static Future<bool> logout(BuildContext context) async {
    try {
      final token = await StorageService.getToken();

      if (token == null) {
        return true;
      }
      await StorageService.clearToken(); // Clear token from local storage

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged out successfully')),
      );

      return true;
    } catch (e) {
      showAuthError(context, 'An error occurred during logout.');
      return false;
    }
  }

  //  Signup new user
  static Future<bool> signup(String userType, String email, String password) async {
    try {
      print('Sending userType: $userType');
      await StorageService.clearToken(); // Clear previous session token
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
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['token'] != null) {
          await StorageService.saveToken(data['token']); // Save new token
        }
        return true;
      }
      return false;
    } catch (e) {
      print('Signup error: $e');
      return false;
    }
  }

  //  Show authentication error in snackbar
  static void showAuthError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
