import 'bottom_navigation.dart';
import 'gradient_bg.dart';
import 'package:flutter/material.dart';

class StudentProfilePage extends StatelessWidget {
  final Map<String, dynamic> profileData; // Profile data map passed from previous page
  const StudentProfilePage({super.key, required this.profileData});

  @override
  Widget build(BuildContext context) {
    final profile = profileData['profile'] ?? {}; // Extract profile map safely
    final events = profileData['my_events'] as List<dynamic>? ?? []; // Extract user's registered events list or empty list

    return Scaffold(
      extendBodyBehindAppBar: true, // Body extends behind transparent AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent AppBar background
        elevation: 0,
        title: const Text('Profile'), // AppBar title
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Placeholder for navigation to edit profile screen
            },
          ),
        ],
      ),

      body: GradientBackground(
        child: SingleChildScrollView(
          // Scrollable content with padding to avoid notch/toolbar overlap
          padding: const EdgeInsets.fromLTRB(16, kToolbarHeight + 24, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile picture and name section
              Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      profile['profilePicture'] ??
                          'https://via.placeholder.com/150', // Default placeholder image if none provided
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    profile['name'] ?? 'No Name', // Show name or fallback
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${profile['department'] ?? ''} Student', // Show department + "Student"
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Profile info sections with titles and values
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileSection('Department', profile['department'] ?? ''),
                  _buildProfileSection('Graduation Year', profile['graduationYear']?.toString() ?? ''),
                  _buildProfileSection('Email', profile['email'] ?? ''),
                  _buildProfileSection('Student ID', profile['studentId'] ?? ''),
                  _buildProfileSection('Current Job Title', profile['jobTitle'] ?? ''),
                  _buildProfileSection('Company', profile['company'] ?? ''),
                  _buildProfileSection('LinkedIn Profile', profile['linkedin'] ?? ''),

                  // About Me section with placeholder text
                  const Text(
                    'About Me',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: _boxDecoration(),
                    child: const Text(
                      'I am a passionate student eager to make an impact in the tech world.', // Placeholder about me text
                      style: TextStyle(fontSize: 16),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Interests & Skills section with placeholder text
                  const Text(
                    'Interests & Skills',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: _boxDecoration(),
                    child: const Text(
                      'Flutter, Dart, Firebase, AI, UI/UX Design', // Placeholder interests and skills
                      style: TextStyle(fontSize: 16),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Registered events section header
                  const Text(
                    'View Your Registered Event',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // Show first registered event if any, otherwise show "No registered events."
                  if (events.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: _boxDecoration(),
                      child: Column(
                        children: [
                          Text(
                            events[0]['name'] ?? 'Event', // Event name or fallback
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Date: ${events[0]['date'] ?? 'N/A'}\nLocation: ${events[0]['location'] ?? 'N/A'}', // Event date and location
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  else
                    const Text('No registered events.'), // Fallback text if no events
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomNavigation(context: context), // App's bottom navigation bar
    );
  }

  // Helper widget to create a profile info section with a title and value in a decorated container
  Widget _buildProfileSection(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20), // Space below each section
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Left aligned text
        children: [
          Text(
            title, // Section title
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12), // Padding inside container
            decoration: _boxDecoration(), // White background with rounded corners and shadow
            child: Text(
              value, // The info value text
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  // BoxDecoration helper method for consistent white boxes with shadows and rounded corners
  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white, // White background
      borderRadius: BorderRadius.circular(8), // Rounded corners
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2), // Light shadow for depth
          spreadRadius: 1,
          blurRadius: 3,
          offset: const Offset(0, 1), // Shadow direction downwards
        ),
      ],
    );
  }
}
