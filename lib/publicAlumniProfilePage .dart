import 'package:flutter/material.dart';
import 'package:gradbond/models/alumni_model.dart';
import 'gradient_bg.dart';

class PublicAlumniProfilePage extends StatelessWidget {
  final Alumni alumni; // Alumni model passed in for displaying public profile

  const PublicAlumniProfilePage({super.key, required this.alumni});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Allows content to extend behind the transparent app bar
      appBar: AppBar(
        title: Text(alumni.name), // AppBar shows alumni name
        backgroundColor: Colors.transparent, // Transparent background
        elevation: 0,
      ),
      body: GradientBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, kToolbarHeight + 24, 16, 16), // Padding with space for status bar & toolbar
          child: Column(
            children: [
              // Circular avatar for profile picture or placeholder image
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  alumni.profilePicture ?? 'https://via.placeholder.com/150', // Fallback placeholder if no picture
                ),
              ),
              const SizedBox(height: 16),

              // Alumni name in bold large text
              Text(alumni.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),

              // Job title and company
              Text(alumni.jobTitle),
              Text(alumni.company),
              const SizedBox(height: 16),

              // Fields for email, university, department, graduation year, and LinkedIn URL
              _buildField('Email', alumni.email),
              _buildField('University', alumni.university),
              _buildField('Department', alumni.department),
              _buildField('Graduation Year', alumni.graduationYear?.toString() ?? 'N/A'), // Show 'N/A' if null
              _buildField('LinkedIn', alumni.linkedin ?? 'N/A'), // Show 'N/A' if LinkedIn is null
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build labeled info rows with label in bold and value wrapped/expanded
  Widget _buildField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0), // Spacing between fields
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align texts at the top for multi-line values
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)), // Label with bold style
          Expanded(child: Text(value)), // Value text takes remaining horizontal space
        ],
      ),
    );
  }
}
