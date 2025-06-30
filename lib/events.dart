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
  int _currentPage = 1;
  final int _totalPages = 3;
  late Timer _timer;
  late Future<List<Map<String, String>>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _eventsFuture = fetchEvents();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<List<Map<String, String>>> fetchEvents() async {
    final response = await http.get(Uri.parse('https://gradbond.up.railway.app/api/events/'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final List<dynamic> events = json['events'];

      return events.map<Map<String, String>>((event) => {
        "title": event['name'] ?? "No Title",
        "date": event['date'] ?? DateTime.now().toIso8601String(),
        "time": event['time'] ?? "00:00",
        "image": event['image_url'] ?? "assets/images/event_card_placeholder1.png",
        "createdBy": event['created_by'] ?? "Unknown",
        "registrationLink": event['registration_link'] ?? "",
      }).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: const Color.fromARGB(255, 242, 238, 255),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
                      'Recent Events/Workshops',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
        actions: const [
          AppLogo(size: 36),
        ],
      ),
      body: GradientBackground(
        child: SafeArea(
          child: FutureBuilder<List<Map<String, String>>>(
            future: _eventsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }

              final events = snapshot.data!;
              return Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.65,
                          ),
                          itemCount: events.length,
                          itemBuilder: (context, index) {
                            final event = events[index];
                            final parsedDate = DateTime.tryParse(event['date']!);
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
                    currentPage: _currentPage,
                    totalPages: _totalPages,
                    onPageChanged: (page) {
                      setState(() => _currentPage = page);
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: bottomNavigation(context: context),
    );
  }
}

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
  late Timer _timer;
  String _countdown = "00 : 00 : 00 : 00";
  bool _eventEnded = false;

  @override
  void initState() {
    super.initState();
    _updateCountdown();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateCountdown();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateCountdown() {
    final now = DateTime.now();
    final diff = widget.dateTime.difference(now);

    if (diff.isNegative && !_eventEnded) {
      setState(() {
        _countdown = "EVENT ENDED";
        _eventEnded = true;
      });
    } else if (!diff.isNegative) {
      final days = diff.inDays.toString().padLeft(2, '0');
      final hours = (diff.inHours % 24).toString().padLeft(2, '0');
      final minutes = (diff.inMinutes % 60).toString().padLeft(2, '0');
      final seconds = (diff.inSeconds % 60).toString().padLeft(2, '0');

      final newCountdown = "$days : $hours : $minutes : $seconds";
      if (newCountdown != _countdown) {
        setState(() => _countdown = newCountdown);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MMMM d, y').format(widget.dateTime);
    final formattedTime = DateFormat('hh:mm a').format(widget.dateTime);
    return Card(
      elevation: 4,
      color: const Color.fromRGBO(58, 29, 111, 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16 / 10,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  widget.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Color.fromARGB(255, 245, 231, 231),
                    child: Center(child: Icon(Icons.broken_image, size: 40)),
                  ),
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
                    overflow: TextOverflow.ellipsis,
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("No registration link provided")),
                          );
                          return;
                        }
                        final uri = Uri.tryParse(url);
                        if (uri != null && await canLaunchUrl(uri)) {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Could not open the registration link")),
                          );
                        }
                      },
                      child: Text(
                        _eventEnded ? "Recap" : "Register",
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed:
              currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
        ),
        if (currentPage > 2) _buildPageButton(1),
        if (currentPage > 3) const Text("..."),
        for (int i = currentPage - 1; i <= currentPage + 1; i++)
          if (i > 0 && i <= totalPages) _buildPageButton(i),
        if (currentPage < totalPages - 2) const Text("..."),
        if (currentPage < totalPages - 1) _buildPageButton(totalPages),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed:
              currentPage < totalPages ? () => onPageChanged(currentPage + 1) : null,
        ),
      ],
    );
  }

  Widget _buildPageButton(int page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              page == currentPage ? Colors.deepPurple : Colors.grey[300],
          minimumSize: const Size(36, 36),
        ),
        onPressed: () => onPageChanged(page),
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
