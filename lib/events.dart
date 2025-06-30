import 'package:flutter/material.dart';
import 'package:gradbond/app_logo.dart';
import 'package:gradbond/home.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'gradient_bg.dart';
import 'bottom_navigation.dart';
import 'package:url_launcher/url_launcher.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  int _currentPage = 1; // Current page number for pagination
  final int _totalPages = 3; // Total number of pages available
  late Timer _timer; // Timer to update UI every second
  late Future<List<Map<String, String>>> _eventsFuture; // Future holding events data

  @override
  void initState() {
    super.initState();
    _eventsFuture = fetchEvents(); // Fetch events from API when widget initializes

    // Timer triggers UI refresh every second (used for countdown timers)
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel timer to prevent memory leaks
    super.dispose();
  }

  // Fetches events data from remote API and maps to List of Maps
  Future<List<Map<String, String>>> fetchEvents() async {
    final response = await http.get(Uri.parse('https://gradbond.up.railway.app/api/events/'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final List<dynamic> events = json['events'];

      // Map each event JSON object to a Map<String, String> with default fallbacks
      return events.map<Map<String, String>>((event) => {
        "title": event['name'] ?? "No Title",
        "date": event['date'] ?? DateTime.now().toIso8601String(),
        "time": event['time'] ?? "00:00",
        "image": event['image_url'] ?? "assets/images/event_card_placeholder1.png",
        "createdBy": event['created_by'] ?? "Unknown",
        "registrationLink": event['registration_link'] ?? "",
      }).toList();
    } else {
      // Throw error if API call fails
      throw Exception('Failed to load events');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 238, 255),
      extendBodyBehindAppBar: true, // Body extends behind transparent app bar
      appBar: AppBar(
        title: Text(
          'Recent Events/Workshops',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.transparent, // Transparent app bar
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to HomePage on back button press
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
        actions: const [
          AppLogo(size: 36), // Display app logo on app bar
        ],
      ),
      body: GradientBackground(
        child: SafeArea(
          child: FutureBuilder<List<Map<String, String>>>(
            future: _eventsFuture, // Listen for fetched events data
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show loading indicator while fetching data
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // Show error message if fetching fails
                return Center(child: Text("Error: ${snapshot.error}"));
              }

              final events = snapshot.data!; // List of event maps

              return Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0), // Empty padding for spacing
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(), // Disable scrolling inside grid
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Two columns in grid
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.65, // Card aspect ratio
                          ),
                          itemCount: events.length,
                          itemBuilder: (context, index) {
                            final event = events[index];
                            final parsedDate = DateTime.tryParse(event['date']!); // Parse event date

                            return EventCard(
                              title: event['title']!,
                              imagePath: event['image']!,
                              dateTime: parsedDate ?? DateTime.now(),
                              createdBy: event['createdBy']!,
                              time: event['time']!,
                              registrationLink: event['registrationLink'] ?? '',
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  PaginationSection(
                    currentPage: _currentPage, // Current active page number
                    totalPages: _totalPages,   // Total pages available
                    onPageChanged: (page) {
                      setState(() => _currentPage = page); // Update page number on change
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: bottomNavigation(context: context), // Bottom nav bar widget
    );
  }
}

// Card widget to display individual event details
class EventCard extends StatefulWidget {
  final String title;
  final DateTime dateTime;
  final String imagePath;
  final String createdBy;
  final String time;
  final String registrationLink;

  const EventCard({
    super.key,
    required this.title,
    required this.dateTime,
    required this.imagePath,
    required this.createdBy,
    required this.time,
    required this.registrationLink,
  });

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  late Timer _timer; // Timer to update countdown every second
  String _countdown = "00 : 00 : 00 : 00"; // Initial countdown string
  bool _eventEnded = false; // Flag to check if event has ended

  @override
  void initState() {
    super.initState();
    _updateCountdown(); // Initialize countdown on start

    // Update countdown every second
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateCountdown();
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel timer to avoid memory leaks
    super.dispose();
  }

  // Update countdown string based on current time and event time
  void _updateCountdown() {
    final now = DateTime.now();
    final diff = widget.dateTime.difference(now);

    if (diff.isNegative && !_eventEnded) {
      // If event time passed and flag not set yet, show "EVENT ENDED"
      setState(() {
        _countdown = "EVENT ENDED";
        _eventEnded = true;
      });
    } else if (!diff.isNegative) {
      // Calculate days, hours, minutes, seconds remaining
      final days = diff.inDays.toString().padLeft(2, '0');
      final hours = (diff.inHours % 24).toString().padLeft(2, '0');
      final minutes = (diff.inMinutes % 60).toString().padLeft(2, '0');
      final seconds = (diff.inSeconds % 60).toString().padLeft(2, '0');

      final newCountdown = "$days : $hours : $minutes : $seconds";

      // Update countdown only if it changed to avoid unnecessary rebuilds
      if (newCountdown != _countdown) {
        setState(() => _countdown = newCountdown);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MMMM d, y').format(widget.dateTime); // Format event date
    final formattedTime = DateFormat('hh:mm a').format(widget.dateTime);   // Format event time

    return Card(
      elevation: 4,
      color: const Color.fromRGBO(58, 29, 111, 1), // Purple background color
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), // Rounded corners
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {}, // Placeholder for tap action (none currently)
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16 / 10, // Image aspect ratio
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  widget.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Color.fromARGB(255, 245, 231, 231),
                    child: Center(child: Icon(Icons.broken_image, size: 40)),
                  ), // Show broken image icon on load failure
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis, // Truncate overflow text
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Created By: ${widget.createdBy}",
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "$formattedDate | $formattedTime",
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 8, 6, 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.1),
                        minimumSize: const Size(0, 36), 
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        final url = widget.registrationLink;
                        if (url.isEmpty) {
                          // Show error if no registration link
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("No registration link provided")),
                          );
                          return;
                        }
                        final uri = Uri.tryParse(url);
                        if (uri != null && await canLaunchUrl(uri)) {
                          // Open registration link in external browser
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        } else {
                          // Show error if link cannot be opened
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Could not open the registration link")),
                          );
                        }
                      },
                      child: Text(
                        _eventEnded ? "Recap" : "Register", // Change button text if event ended
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget for pagination buttons below the event grid
class PaginationSection extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;

  const PaginationSection({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // Center pagination buttons
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed:
              currentPage > 1 ? () => onPageChanged(currentPage - 1) : null, // Previous page
        ),
        if (currentPage > 2) _buildPageButton(1), // First page button if far enough
        if (currentPage > 3) const Text("..."),  // Ellipsis for skipped pages
        for (int i = currentPage - 1; i <= currentPage + 1; i++)
          if (i > 0 && i <= totalPages) _buildPageButton(i), // Current page and neighbors
        if (currentPage < totalPages - 2) const Text("..."), // Ellipsis after current page
        if (currentPage < totalPages - 1) _buildPageButton(totalPages), // Last page button
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed:
              currentPage < totalPages ? () => onPageChanged(currentPage + 1) : null, // Next page
        ),
      ],
    );
  }

  // Builds a numbered page button
  Widget _buildPageButton(int page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              page == currentPage ? Colors.deepPurple : Colors.grey[300], // Highlight current page
          minimumSize: const Size(36, 36),
        ),
        onPressed: () => onPageChanged(page), // Change to selected page on press
        child: Text(
          '$page',
          style: TextStyle(
            color: page == currentPage ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
