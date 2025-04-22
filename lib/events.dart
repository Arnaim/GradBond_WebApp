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
  child: SafeArea(
    child: SingleChildScrollView(
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              shrinkWrap: true, // <- Important
              physics: const NeverScrollableScrollPhysics(), // Disable internal scroll
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.65,
              ),
              itemCount: dummyEvents.length,
              itemBuilder: (context, index) {
                final event = dummyEvents[index];
                final parsedDate = DateTime.tryParse(event['date']!);
                return EventCard(
                  title: event['title']!,
                  imagePath: event['image']!,
                  dateTime: parsedDate ?? DateTime.now().subtract(const Duration(days: 1)),
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
    "title": "AI: Tech Meetup",
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
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.asset(
                  widget.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color.fromARGB(255, 245, 231, 231),
                    child: const Center(child: Icon(Icons.broken_image, size: 40)),
                  ),
                ),
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                widget.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Countdown
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  Text(
                    _eventEnded ? "EVENT COMPLETED" : "TIME REMAINING",
                    style: const TextStyle(fontSize: 9, color: Colors.white),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _countdown,
                        style: const TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
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
                        onPressed: () {},
                        child: Text(
                          _eventEnded ? "Recap" : "Register",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10.5, // go even smaller if needed
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                      )
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: const Size(90, 36), // 🔥 Add width (90 is usually safe)
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: Colors.white.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "See more",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                    )
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
