import 'package:flutter/material.dart';
import 'gradient_bg.dart';
import 'bottom_navigation.dart';

class AlumniProfilePage extends StatelessWidget {
  final Map<String, dynamic> profileData;
  const AlumniProfilePage({super.key, required this.profileData});

  @override
  Widget build(BuildContext context) {
    final profile = profileData['profile'] ?? {};

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
                          '${profile['department'] ?? ''} Graduate',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Profile Info
                    _buildProfileSection('Department', profile['department'] ?? ''),
                    _buildProfileSection('Graduation Year', profile['graduationYear']?.toString() ?? ''),
                    _buildProfileSection('Email', profile['email'] ?? ''),
                    _buildProfileSection('Student ID', profile['studentId'] ?? ''),
                    _buildProfileSection('Current Job Title', profile['jobTitle'] ?? ''),
                    _buildProfileSection('Company', profile['company'] ?? ''),
                    _buildProfileSection('LinkedIn Profile', profile['linkedin'] ?? ''),

                    // About Me - placeholder for now
                    _buildLargeProfileSection(
                      'About Me',
                      'Experienced professional in the tech industry who loves innovation and problem-solving.',
                    ),

                    // Interests & Skills - placeholder
                    _buildLargeProfileSection(
                      'Interests & Skills',
                      'Flutter, Dart, Firebase, Backend Systems, Project Management',
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Bottom Buttons for alumni
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, -1),
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
      bottomNavigationBar: bottomNavigation(context: context),
    );
  }

  Widget _buildProfileSection(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
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
            ),
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLargeProfileSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
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
            ),
            child: Text(
              content,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPurpleButton(String text, IconData icon) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF3A1D6F),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () {
        // Add button functionality here
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
