import 'package:flutter/material.dart';
import 'package:gradbond/services/api_service.dart'; 
import 'profile_alumni.dart';
import 'profile_student.dart';

class bottomNavigation extends StatelessWidget{
  final BuildContext context;
  const bottomNavigation({super.key, required this.context});  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildNavItem(
          icon: Icons.people,
          label: "Find Alumni",
          onPressed: () {
            Navigator.pushNamed(context, "/search");
          },
        ),
        _buildNavItem(
          icon: Icons.event,
          label: "Events",
          onPressed: () {
            Navigator.pushNamed(context, "/event");
          },
        ),
         _buildNavItem(
            icon: Icons.work,
            label: "Jobs",
            onPressed: () {
              Navigator.pushNamed(context, "/jobs");
            },
          ),
         _buildNavItem(
          icon: Icons.logout,
          label: "Log out",
          onPressed: () => _showLogoutDialog(context),
        ),
       _buildNavItem(
          icon: Icons.person,
          label: "You",
          onPressed: () {
            _navigateToProfile(context);
          },
        ),
      ],
    );
  }

  Widget _buildNavItem({
        required IconData icon,
        required String label,
        required VoidCallback onPressed,
        }
       ) 
      {
        const navColor = Color.fromRGBO(58, 29, 111, 1); 
        return TextButton(
          onPressed: onPressed,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: navColor),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(color: navColor),
              ),
            ],
          ),
        );
      }
    }

void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout", style: TextStyle(color: Colors.black)),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog first
              final success = await AuthService.logout(context);
              if (success) {
                // Clear entire navigation stack and go to login
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login',
                  (route) => false,
                );
              }
            },
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }


void _navigateToProfile(BuildContext context) async {
  final profileData = await ApiService.fetchMyProfile();

  if (profileData != null && profileData['profile'] != null) {
    final userType = profileData['profile']['userType'];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => userType == 'student'
            ? StudentProfilePage(profileData: profileData)
            : AlumniProfilePage(profileData: profileData),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to load profile.')),
    );
  }
}