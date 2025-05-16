import 'package:flutter/material.dart';
import 'bottom_navigation.dart'; // Import the bottom navigation bar
import 'gradient_bg.dart';

class ProfileAlumni extends StatelessWidget {
  const ProfileAlumni({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
      //backgroundColor: const Color(0xFFF4F0FF),
      bottomNavigationBar: bottomNavigation(context: context),
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
                'Alumni - Dhaka University',
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
                child: const Text('Edit Your Profile',
                    style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 20),
              _infoCard(
                  'Department', 'Computer Science', 'Graduation Year', '2017'),
              _infoCard(
                  'Email', 'amimamu420@gmail.com', 'Phone', '+8801956743629'),
              _infoCard('Current Job Title', 'Product Manager',
                  'Graduation Year', '2017'),
              _infoCard(
                  'Linkedin Profile',
                  'https://www.linkedin.com/in/azmain-hasan-daiyan-3b8b0431/',
                  '',
                  ''),
              _sectionCard('About Me',
                  'Former Software Engineer with a passion for product management and 420. Live and Die for Krishnopur. Don\'t wanna be like Alkas.'),
              _sectionCard(
                'Interests & Skills',
                '',
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: const [
                    _SkillChip('UI/UX'),
                    _SkillChip('Product Management'),
                    _SkillChip('Gardening'),
                    _SkillChip('ReactJS'),
                    _SkillChip('Distributed Database'),
                    _SkillChip('Data Structure'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _actionButton('Create an Event'),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _actionButton('View Your Events'),
                  ),
                ],
              )
            ],
          ),
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
        boxShadow: [
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
            Text('$label2: $value2', style: const TextStyle(fontSize: 16))
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
        boxShadow: [
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
  const _SkillChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black,
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