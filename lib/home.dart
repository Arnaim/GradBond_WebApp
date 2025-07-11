import 'package:flutter/material.dart';
import 'package:gradbond/app_logo.dart';
import 'bottom_navigation.dart';
import 'package:gradbond/gradient_bg.dart';
import 'package:gradbond/models/alumni_model.dart';
import 'package:gradbond/models/event_model.dart';
import 'package:gradbond/services/api_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Event>> _eventsFuture;  // Future to hold events data for async loading

  // Function to fetch events data directly from API endpoint
  Future<List<Event>> fetchEventsDirect() async {
    final response = await http.get(
      Uri.parse('https://gradbond.up.railway.app/api/events/'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> eventsJson = data['events'];
      // Map JSON data to list of Event model objects
      return eventsJson.map((e) => Event.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load events: ${response.statusCode}');
    }
  }

  late Future<List<Alumni>> _alumniFuture;  // Future for alumni data async loading

  @override
  void initState() {
    super.initState();
    _eventsFuture = fetchEventsDirect(); // Initialize future to fetch events
    _alumniFuture = ApiService.fetchAlumniForHome(); // Initialize future for alumni data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar with title and app logo on the right
      appBar: AppBar(
        title: Text(
            "Welcome back to Gradbond",
             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
        actions: const [
          AppLogo(size: 36),
        ],
      ),

      // Body with gradient background and scrollable column content
      body: GradientBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quick action buttons to navigate to different pages
              _buildActionButton(context, "Search For Alumni", Icons.search, "/search"),
              const SizedBox(height: 16),
              _buildActionButton(context, "Browse Events", Icons.event, "/event"),
              const SizedBox(height: 16),
              _buildActionButton(context, "Go To Jobs", Icons.work, "/jobs"),
              const SizedBox(height: 30),

              // Section title for upcoming events
              const Text("Upcoming Events", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              // FutureBuilder to handle events data async loading and UI rendering
              FutureBuilder<List<Event>>(
                future: _eventsFuture,
                builder: (context, snapshot) {
                  print('FutureBuilder snapshot: state=${snapshot.connectionState}, hasData=${snapshot.hasData}, hasError=${snapshot.hasError}');

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show loading spinner while waiting for data
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    // Show error message if loading fails
                    print('FutureBuilder error: ${snapshot.error}');
                    return Text('Failed to load events: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    // Show message if no event data is found
                    print('FutureBuilder: No events data found or empty');
                    return const Text("No events available.");
                  }

                  final events = snapshot.data!;
                  // Horizontal list view to display event cards
                  return SizedBox(
                    height: 280,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: events.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return _buildEventCard(event.name, event.date, event.imageUrl, event.registrationLink);
                      },
                    ),
                  );
                },
              ),

              const SizedBox(height: 25),

              // Section title for alumni connections
              const Text("Connect with Alumni", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              // FutureBuilder for alumni list async loading and UI
              FutureBuilder<List<Alumni>>(
                future: _alumniFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show loading indicator while fetching alumni data
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    // Show error message on failure
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                    // Show message if no alumni found
                    return const Text("No alumni found.");
                  }

                  final alumniList = snapshot.data!;
                  // Show up to 5 alumni cards vertically
                  return Column(
                    children: alumniList.take(5).map((alumni) {
                      return _buildAlumniCard(
                        alumni.name,
                        alumni.jobTitle,
                        alumni.company,
                        alumni.university,
                        alumni.profilePicture ?? "",
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),

      // Bottom navigation bar imported from your shared component
      bottomNavigationBar: bottomNavigation(context: context),
    );
  }

  // Widget for quick action buttons on home page
  Widget _buildActionButton(BuildContext context, String text, IconData icon, String routeName) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 24, color: Colors.black),
        label: Text(text, style: const TextStyle(fontSize: 16, color: Colors.black)),
        onPressed: () => Navigator.pushNamed(context, routeName),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 20),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  // Widget to build each event card for the events list
  Widget _buildEventCard(String title, String date, String imageUrl, String registrationLink) {
  return SizedBox(
    width: 180,
    child: Card(
      color: const Color.fromRGBO(58, 29, 111, 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Event image container with network image
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {}, // Handle image loading errors gracefully
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event title text
                  Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Event date text
                  Text(
                    date,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const Spacer(), 
                  Center(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.1),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () async {
                        if (registrationLink.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("No registration link provided")),
                          );
                          return;
                        }
                        final uri = Uri.tryParse(registrationLink);
                        if (uri != null && await canLaunchUrl(uri)) {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Could not open the registration link")),
                          );
                        }
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  // Widget to build each alumni card for the alumni list
  Widget _buildAlumniCard(String name, String position, String company, String university, String imageUrl) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Alumni profile picture avatar
            CircleAvatar(
              radius: 28,
              backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
              backgroundColor: Colors.grey[300], // Default background color if no image
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Alumni name
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  // Alumni job title
                  Text(position, style: TextStyle(color: Colors.grey[600])),
                  // Alumni company
                  Text(company, style: TextStyle(color: Colors.grey[600])),
                  // Alumni university
                  Text(university, style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
