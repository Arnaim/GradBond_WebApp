import 'package:flutter/material.dart';

// A simple widget that displays the app logo image.
// Can specify the size, default is 32x32 pixels.
class AppLogo extends StatelessWidget {
  // Constructor with optional size parameter
  const AppLogo({Key? key, this.size = 32}) : super(key: key);

  // Size of the logo (width and height)
  final double size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Add some right padding so the logo has space before next widget (like title)
      padding: const EdgeInsets.only(right: 12),
      child: Image.asset(
        // Path to your logo image asset
        'assets/images/logo.png',
        width: size,  // Set width of the logo
        height: size, // Set height of the logo
        fit: BoxFit.contain, // Scale the image to fit inside box without cropping
      ),
    );
  }
}
