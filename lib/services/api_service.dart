import 'dart:convert';
import 'package:http/http.dart' as http;
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


