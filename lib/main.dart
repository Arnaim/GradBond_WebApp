import 'package:flutter/material.dart';
import 'package:gradbond/find_alumni.dart';
import 'package:gradbond/home.dart';
import 'package:gradbond/services/storage/storage_mobile.dart';
import 'login.dart'; 
import 'signup_page.dart';
import 'events.dart';
import 'jobs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures everything is ready before runApp

  final token = await StorageService.getToken(); // Get saved token (if logged in)

  runApp(MyApp(isLoggedIn: token != null)); // Start app with login status
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn; // Whether user is logged in or not
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hide debug banner
      home: isLoggedIn ? const HomePage() : const GradBond(), // Show home if logged in, else landing page
      routes: {
          '/home': (context) => HomePage(),
          '/login': (context) => const LoginScreen(),  
          '/search': (context) =>  FindAlumni(),
          '/signup': (context) => const SignUpPage(), 
          '/event': (context) => EventsPage(),
          '/jobs': (context) => const JobBoardPage()
        },
    );
  }
}

class GradBond extends StatelessWidget {
  const GradBond({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              SizedBox(
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                child: Image.asset(
                  'assets/images/landingPage.png', // Background image
                  fit: BoxFit.cover,
                ),
              ),
              SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Image.asset(
                          'assets/images/logo.png', // Logo
                          height: 150,
                          width: 300,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Connect, discover, and grow", // Tagline
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: Color.fromRGBO(41, 69, 98, 1),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Build your alumni network today.', // Subtitle
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromRGBO(53, 57, 58, 1),
                          ),
                        ),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(1, 87, 182, 1), // Blue login button
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/login'); // Go to login
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUpPage()), // Go to sign up
                              );
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        const Text(
                          '© 2025 Conditional, All Rights Reserved.', // Footer text
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(offset: Offset(-1, -1), color: Colors.black),
                              Shadow(offset: Offset(1, -1), color: Colors.black),
                              Shadow(offset: Offset(1, 1), color: Colors.black),
                              Shadow(offset: Offset(-1, 1), color: Colors.black),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
