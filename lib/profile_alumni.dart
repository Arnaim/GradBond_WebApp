import 'package:flutter/material.dart';
import 'gradient_bg.dart';
import 'bottom_navigation.dart';

class AlumniProfilePage extends StatelessWidget {
  final Map<String, dynamic> profileData; // Profile data passed in from previous page
  const AlumniProfilePage({super.key, required this.profileData});

  @override
  Widget build(BuildContext context) {
    final profile = profileData['profile'] ?? {}; // Extract profile map safely

    return Scaffold(
      extendBodyBehindAppBar: true, // Body extends behind transparent AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent AppBar
        elevation: 0,
        title: const Text('Profile'), // Title shown in AppBar
        centerTitle: true, // Center the title text
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Placeholder for edit profile navigation
              // Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage()));
            },
          ),
        ],
      ),
      body: GradientBackground(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                // Scrollable content with padding to avoid notch/toolbar overlap
                padding: const EdgeInsets.fromLTRB(16, kToolbarHeight + 24, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profile picture and basic info
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                            profile['profilePicture'] ??
                                'https://via.placeholder.com/150', // Default image if none provided
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          profile['name'] ?? 'No Name', // Show name or fallback text
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${profile['department'] ?? ''} Graduate', // Show department with "Graduate"
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Various profile info sections with title and value
                    _buildProfileSection('Department', profile['department'] ?? ''),
                    _buildProfileSection('Graduation Year', profile['graduationYear']?.toString() ?? ''),
                    _buildProfileSection('Email', profile['email'] ?? ''),
                    _buildProfileSection('Student ID', profile['studentId'] ?? ''),
                    _buildProfileSection('Current Job Title', profile['jobTitle'] ?? ''),
                    _buildProfileSection('Company', profile['company'] ?? ''),
                    _buildProfileSection('LinkedIn Profile', profile['linkedin'] ?? ''),

                    // About Me section with placeholder text
                    _buildLargeProfileSection(
                      'About Me',
                      'Experienced professional in the tech industry who loves innovation and problem-solving.',
                    ),

                    // Interests & Skills section with placeholder text
                    _buildLargeProfileSection(
                      'Interests & Skills',
                      'Flutter, Dart, Firebase, Backend Systems, Project Management',
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Bottom bar with buttons for creating event or job
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2), // Soft shadow above container
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, -1), // Shadow above (upwards)
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildPurpleButton('Create an Event', Icons.add),
                  _buildPurpleButton('Create a Job', Icons.work),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: bottomNavigation(context: context), // Bottom navigation bar from your app
    );
  }

  // Helper widget for showing a titled info section with value inside a white card
  Widget _buildProfileSection(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16), // Space below section
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Left align text
        children: [
          Text(
            title, // Section title (e.g., Department)
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white, // White background for info box
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2), // Light shadow for depth
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Text(
              value, // The actual info value
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  // Similar to _buildProfileSection but for larger content (e.g., About Me)
  Widget _buildLargeProfileSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16), // Space below section
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Left align text
        children: [
          Text(
            title, // Section title
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16), // More padding for larger text
            decoration: BoxDecoration(
              color: Colors.white, // White background
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2), // Light shadow
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Text(
              content, // Larger content text
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  // Button styled with purple background and icon + text
  Widget _buildPurpleButton(String text, IconData icon) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF3A1D6F), // Deep purple
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () {
        // Placeholder for button functionality (create event/job)
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white), // Icon in white
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(color: Colors.white), // Text in white
          ),
        ],
      ),
    );
  }
}
