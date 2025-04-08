import 'package:flutter/material.dart';

class SignupChoiceDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Choose Account Type"),
          content: const Text("Are you signing up as a Student or Alumni?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pushNamed(context, '/signup'); // Student
              },
              child: const Text("Student"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pushNamed(context, '/alumni-signup'); // Alumni
              },
              child: const Text("Alumni"),
            ),
          ],
        );
      },
    );
  }
}