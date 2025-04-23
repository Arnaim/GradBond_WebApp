import 'package:flutter/material.dart';

class bottomNavigation extends StatelessWidget {
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
          icon: Icons.logout,
          label: "Log out",
          onPressed: () {
            _showLogoutDialog(context);
          },
        ),
        _buildNavItem(
          icon: Icons.person,
          label: "You",
          onPressed: () {
            _showUserTypeDialog(context);
          },
        ),
      ],
    );
  }

  Widget _buildNavItem(
      {required IconData icon,
      required String label,
      required VoidCallback onPressed}) {
    return TextButton(
      onPressed: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.black),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.black),
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
      title: const Text(
        "Logout",
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      content: const Text("Are you sure you want to logout?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            "Cancel",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/login');
          },
          child: const Text(
            "Logout",
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        )
      ],
    ),
  );
}

void _showUserTypeDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Select User Type"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text("Alumni"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/profile_alumni");
            },
          ),
          ListTile(
            title: const Text("Student"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                  context, "/profile_student"); // Added student navigation
            },
          ),
        ],
      ),
    ),
  );
}
