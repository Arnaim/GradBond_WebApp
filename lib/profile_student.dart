import 'package:flutter/material.dart';
import 'bottom_navigation.dart'; // Import the shared navigation

class ProfileStudent extends StatelessWidget {
  const ProfileStudent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F0FF),
      bottomNavigationBar:
          bottomNavigation(context: context), // Use shared navigation
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('assets/profile.png'),
              ),
              const SizedBox(height: 12),
              const Text(
                'Ai Shaker',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Student - BUBT',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Edit Your Profile',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              _infoCard('Department', 'Computer Science', 'Student ID',
                  'BUBT-CSE-2021-001'),
              _infoCard(
                  'Email', 'amimamu420@gmail.com', 'Phone', '+8801956743629'),
              _infoCard(
                  'Current Semester', '8th', 'Expected Graduation', '2024'),
              _infoCard(
                  'Linkedin Profile',
                  'https://www.linkedin.com/in/azmain-hasan-daiyan-3b8b0431/',
                  '',
                  ''),
              _sectionCard('About Me',
                  'Computer Science student passionate about software development. Active in campus programming competitions and open source contributions.'),
              _sectionCard(
                'Interests & Skills',
                '',
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: const [
                    _SkillChip('Flutter'),
                    _SkillChip('Dart'),
                    _SkillChip('UI/UX'),
                    _SkillChip('Competitive Programming'),
                    _SkillChip('Data Structures'),
                    _SkillChip('Algorithms'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _actionButton('Create Study Group'),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _actionButton('View Campus Events'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  static Widget _infoCard(
      String label1, String value1, String label2, String value2) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label1: $value1', style: const TextStyle(fontSize: 16)),
          if (label2.isNotEmpty)
            Text('$label2: $value2', style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  static Widget _sectionCard(String title, String content, {Widget? child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          child ?? Text(content, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  static Widget _actionButton(String title) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

class _SkillChip extends StatelessWidget {
  final String label;
  const _SkillChip(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black, // Changed to black (matching alumni profile)
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
    );
  }
}
