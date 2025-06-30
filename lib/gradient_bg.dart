import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child; // The child widget to display inside the gradient background

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        // Define a linear gradient background
        gradient: LinearGradient(
          colors: [
            Color(0xFFE3DAFF), // Light purple color start
            Color(0xFFE8E5E5), // Light grayish white color end
          ],
          begin: Alignment.topLeft, // Gradient starts from top left
          end: Alignment.bottomRight, // Gradient ends at bottom right
        ),
      ),
      child: child, // Place the provided child widget on top of the gradient
    );
  }
}
