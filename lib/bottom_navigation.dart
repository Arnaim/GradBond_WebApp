import 'package:flutter/material.dart';
import 'package:gradbond/services/api_service.dart'; 
import 'profile_alumni.dart';
import 'profile_student.dart';

// Bottom navigation bar widget used on many pages
class bottomNavigation extends StatelessWidget{
  final BuildContext context;  // Context passed from parent widget
  const bottomNavigation({super.key, required this.context});  

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,  // Even spacing for nav items
      children: [
        // "Find Alumni" button
        _buildNavItem(
          icon: Icons.people,
          label: "Find Alumni",
          onPressed: () {
            Navigator.pushNamed(context, "/search");  // Navigate to search page
          },
        ),
        // "Events" button
        _buildNavItem(
          icon: Icons.event,
          label: "Events",
          onPressed: () {
            Navigator.pushNamed(context, "/event");  // Navigate to events page
          },
        ),
        // "Jobs" button
        _buildNavItem(
            icon: Icons.work,
            label: "Jobs",
            onPressed: () {
              Navigator.pushNamed(context, "/jobs");  // Navigate to jobs page
            },
          ),
        // "Log out" button
         _buildNavItem(
          icon: Icons.logout,
          label: "Log out",
          onPressed: () => _showLogoutDialog(context),  // Show logout confirmation dialog
        ),
        // "You" button - goes to profile page depending on user type
       _buildNavItem(
          icon: Icons.person,
          label: "You",
          onPressed: () {
            _navigateToProfile(context);  // Fetch profile and navigate accordingly
          },
        ),
      ],
    );
  }

  // Helper to build a navigation button with icon and label
  Widget _buildNavItem({
        required IconData icon,
        required String label,
        required VoidCallback onPressed,
        }
       ) 
      {
        const navColor = Color.fromRGBO(58, 29, 111, 1);  // Purple color used throughout nav
        return TextButton(
          onPressed: onPressed,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: navColor),  // Icon for the nav item
              const SizedBox(height: 4),
              Text(
                label,  // Text label
                style: const TextStyle(color: navColor),
              ),
            ],
          ),
        );
      }
    }

// Shows a confirmation dialog before logging out
void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout", style: TextStyle(color: Colors.black)),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),  // Close dialog on cancel
            child: const Text("Cancel", style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog first
              final success = await AuthService.logout(context);  // API call to logout

              if (success) {
                // Navigate to login page and clear back stack after successful logout
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

// Fetches logged-in user's profile via API and navigates to correct profile page
void _navigateToProfile(BuildContext context) async {
  final profileData = await ApiService.fetchMyProfile();  // API call to get profile data

  if (profileData != null && profileData['profile'] != null) {
    final userType = profileData['profile']['userType'];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => userType == 'student'
            ? StudentProfilePage(profileData: profileData)  // Navigate to student profile
            : AlumniProfilePage(profileData: profileData),  // Navigate to alumni profile
      ),
    );
  } else {
    // Show error if profile failed to load
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to load profile.')),
    );
  }
}
