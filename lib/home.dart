import 'package:flutter/material.dart';
import 'bottom_navigation.dart';
import 'package:gradbond/gradient_bg.dart';


class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Section
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "Welcome back to Gradbond",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Quick Actions Column
                Column(
                  children: [
                    _buildActionButton(context,"Search For Alumni", Icons.search, "/search"),
                    const SizedBox(height: 16),
                    _buildActionButton(context, "Browse Events", Icons.event ,"/event"),
                    const SizedBox(height: 16),
                    _buildActionButton(context, "Go To Jobs", Icons.work, "/jobs"),
                  ],
                ),
                const SizedBox(height: 20),

                // Upcoming Events Section with horizontal scroll
                const Text(
                  "Upcoming Events",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                      SizedBox(
                        height: 280,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: dummyEvents.length,
                          separatorBuilder: (context, index) => const SizedBox(width: 24),
                          itemBuilder: (context, index) {
                            final event = dummyEvents[index];
                            return _buildEventCard(event["title"]!, event["date"]!, event["image"]!);
                          },
                        ),
                      ),

                const SizedBox(height: 25),

                // Connect with Alumni Section
                const Text(
                  "Connect with Alumni",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                  const SizedBox(height: 20),
                   TextButton(
                  onPressed: () {},
                  child: const Text("See All Alumni"),
                ), 
                _buildAlumniCard("Mahfuz", "Product Engineer", "BUBT Corporation", "BUBT", "assets/images/mahfuz.jpg"),
                _buildAlumniCard("Shaker", "Product Engineer", "Krisnopur Corporation", "DU", "assets/images/shaker.jpg"),
                _buildAlumniCard("Rafiul", "Product Engineer", "Chinese Corporation", "RUET", "assets/images/rafiul.jpg"),
                _buildAlumniCard("Daiyan", "Designer", "Mohammadpur Corporation", "BUET", "assets/images/daiyan.jpg"),
                _buildAlumniCard("Arnab", "Product Engineer", "Nazi Corporation", "BUBT", "assets/images/arnab.jpeg"),
            
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: bottomNavigation(context: context),
    );
  }

  final List<Map<String, String>> dummyEvents = [
  {
    "title": "Graduation Ceremony",
    "date": "May 24, 2024",
    "image": "assets/images/event_card_placeholder1.png",
  },
  {
    "title": "Alumni (Iftar Party)",
    "date": "Postponed",
    "image": "assets/images/event_card_placeholder2.png",
  },
  {
    "title": "Tech Conference",
    "date": "June 10, 2024",
    "image": "assets/images/event_card_placeholder3.png",
  },
  {
  "title": "Future of AI: Tech Meetup",
  "date": "July 15, 2024",
  "image": "assets/images/event_card_placeholder4.png",
  },
  {
  "title": "Startup Pitch Night",
  "date": "August 2, 2024",
  "image": "assets/images/event_card_placeholder5.png",
  }
];


Widget _buildActionButton(BuildContext context, String text, IconData icon, String routeName) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton.icon(
      icon: Icon(icon, size: 24),
      label: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
      ),
      onPressed: () {
        Navigator.pushNamed(context, routeName);
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );
}

Widget _buildEventCard(String title, String date, String imagePath) {
  return SizedBox(
    width: 180,
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: const Color.fromRGBO(58, 29, 111, 1), // Set the background color for the entire Card
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image Section
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Text Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'View Details',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Color.fromRGBO(58, 29, 111, 1),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}



Widget _buildAlumniCard(String name, String position, String company, String university, String imageUrl) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Image
          CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage(imageUrl), 
            backgroundColor: Colors.grey[300],
          ),
          const SizedBox(width: 16),

          // Left Side (Name, Position, Company)
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  position,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                Text(
                  company,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Right Side (University + Description)
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  university,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Requires maximum of increase net revenues\nCorporate turnover in long-term\n2017",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
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


