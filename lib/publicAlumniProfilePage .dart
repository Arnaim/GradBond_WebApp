import 'package:flutter/material.dart';
import 'package:gradbond/models/alumni_model.dart';
import 'gradient_bg.dart';

class PublicAlumniProfilePage extends StatelessWidget {
  final Alumni alumni;

  const PublicAlumniProfilePage({super.key, required this.alumni});

  @override
  Widget build(BuildContext context) {
return Scaffold(
  extendBodyBehindAppBar: true,
  appBar: AppBar(
    title: Text(alumni.name),
    backgroundColor: Colors.transparent,
    elevation: 0,
  ),
  body: GradientBackground(
    child: SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, kToolbarHeight + 24, 16, 16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
              alumni.profilePicture ?? 'https://via.placeholder.com/150',
            ),
          ),
          const SizedBox(height: 16),
          Text(alumni.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(alumni.jobTitle),
          Text(alumni.company),
          const SizedBox(height: 16),
          _buildField('Email', alumni.email),
          _buildField('University', alumni.university),
          _buildField('Department', alumni.department),
          _buildField('Graduation Year', alumni.graduationYear?.toString() ?? 'N/A'),
          _buildField('LinkedIn', alumni.linkedin ?? 'N/A'),
        ],
      ),
    ),
  ),
);
  }

  Widget _buildField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
