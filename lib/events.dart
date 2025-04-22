import 'package:flutter/material.dart';
import 'dart:async';
import 'gradient_bg.dart';
import 'bottom_navigation.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  int _currentPage = 1;
  final int _totalPages = 3;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 238, 255),
      body: GradientBackground(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Recent Events/Workshops',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: dummyEvents.length,
                itemBuilder: (context, index) {
                  final event = dummyEvents[index];
                  final parsedDate = DateTime.tryParse(event['date']!);
                  return EventCard(
                    title: event['title']!,
                    imagePath: event['image']!,
                    dateTime: parsedDate ??
                    DateTime.now().subtract(const Duration(days: 1)),
                  );
                },
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
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: bottomNavigation(context: context),
            ),
          ],
        ),
      ),
    );
  }
}

final List<Map<String, String>> dummyEvents = [
  {
    "title": "Graduation Ceremony",
    "date": "2024-05-24 15:00:00",
    "image": "assets/images/event_card_placeholder1.png",
  },
  {
    "title": "Alumni (Iftar Party)",
    "date": "2025-06-01 18:00:00",
    "image": "assets/images/event_card_placeholder2.png",
  },
  {
    "title": "Tech Conference",
    "date": "2025-06-10 10:00:00",
    "image": "assets/images/event_card_placeholder3.png",
  },
  {
    "title": "Future of AI: Tech Meetup",
    "date": "2025-07-15 14:00:00",
    "image": "assets/images/event_card_placeholder4.png",
  },
  {
    "title": "Startup Pitch Night",
    "date": "2025-08-02 19:00:00",
    "image": "assets/images/event_card_placeholder5.png",
  },
  {
    "title": "Annual Alumni Meetup",
    "date": "2025-09-05 17:30:00",
    "image": "assets/images/event_card_placeholder6.png",
  },
];

class EventCard extends StatefulWidget {
  final String title;
  final DateTime dateTime;
  final String imagePath;

  const EventCard({
    super.key,
    required this.title,
    required this.dateTime,
    required this.imagePath,
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
    return Card(
      elevation: 4,
      color: const Color.fromRGBO(58, 29, 111, 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                widget.imagePath,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 120,
                  color: const Color.fromARGB(255, 245, 231, 231),
                  child: const Icon(Icons.broken_image, size: 40),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Center(
                child: Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  Text(
                    _eventEnded ? "EVENT COMPLETED" : "TIME REMAINING",
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: _eventEnded ? const Color.fromARGB(255, 255, 255, 255) : const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _countdown,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        backgroundColor: Colors.white,
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
              Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          // Handle registration/view recap
                        },
                        child: Text(
                          _eventEnded ? "Recap" : "Register",
                          style: const TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                           // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "See more",
                        style: TextStyle(color: Color.fromARGB(255, 255, 255, 255),//fontWeight: FontWeight.bold
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
