import 'bottom_navigation.dart';
import 'gradient_bg.dart';
import 'package:flutter/material.dart';

class StudentProfilePage extends StatelessWidget {
  final Map<String, dynamic> profileData;
  const StudentProfilePage({super.key, required this.profileData});

  @override
  Widget build(BuildContext context) {
    final profile = profileData['profile'] ?? {};
    final events = profileData['my_events'] as List<dynamic>? ?? [];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to edit profile page
            },
          ),
        ],
      ),
      
      body: GradientBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, kToolbarHeight + 24, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Picture and Name
              Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      profile['profilePicture'] ??
                          'https://via.placeholder.com/150',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    profile['name'] ?? 'No Name',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${profile['department'] ?? ''} Student',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Profile Info
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
                      'I am a passionate student eager to make an impact in the tech world.', // Placeholder
                      style: TextStyle(fontSize: 16),
                    ),
                  ),

                  const SizedBox(height: 20),

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
                      'Flutter, Dart, Firebase, AI, UI/UX Design', // Placeholder
                      style: TextStyle(fontSize: 16),
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    'View Your Registered Event',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (events.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: _boxDecoration(),
                      child: Column(
                        children: [
                          Text(
                            events[0]['name'] ?? 'Event',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Date: ${events[0]['date'] ?? 'N/A'}\nLocation: ${events[0]['location'] ?? 'N/A'}',
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  else
                    const Text('No registered events.'),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomNavigation(context: context),
    );
  }

  Widget _buildProfileSection(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: _boxDecoration(),
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 1,
          blurRadius: 3,
          offset: const Offset(0, 1),
        ),
      ],
    );
  }
}
