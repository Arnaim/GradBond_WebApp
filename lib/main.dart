import 'package:flutter/material.dart';
import 'package:gradbond/find_alumni.dart';
import 'login.dart'; 
import 'student_signup.dart'; 
import 'alumni_signup.dart';
import 'signup_options.dart';
import 'events.dart';
import 'profile_alumni.dart';
import 'profile_student.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const GradBond(),
     routes: {
          '/login': (context) => const LoginScreen(),  
          '/search': (context) => const FindAlumni(),
          '/signup': (context) => const StudentSignup(), 
          '/alumni-signup': (context) => const AlumniSignup(),
          '/event': (context) => const EventsPage(),
          '/profile_alumni': (context) => const ProfileAlumni(), 
          '/profile_student': (context) => const ProfileStudent(), 
        },
    );
  }
}

class GradBond extends StatelessWidget {
  const GradBond({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/landingPage.png',
              fit: BoxFit.fill,
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20), 
                  Image.asset(
                    'assets/images/logo.png',
                    height: 150,
                    width: 300,
                  ),
                  const SizedBox(height: 10), 
                  const Text(
                    "Connect, discover, and grow",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: Color.fromRGBO(41, 69, 98, 1),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Build your alumni network today.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(53, 57, 58, 1),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,            
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(1, 87, 182, 1),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
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
                          SignupChoiceDialog.show(context); // Using the reusable dialog
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
                    '© 2025 Conditional, All Rights Reserved.',
                    style: TextStyle(
                      color: Color.fromRGBO(41, 69, 98, 1),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Image.asset(
                          'assets/images/facebook.png',
                          height: 48,
                          width: 48,                        
                        ),                                 
                        onPressed: (){},
                      ),
                      IconButton(
                        icon: Image.asset(
                        'assets/images/linkedin.png',
                        height: 32,
                        width: 32, 
                        ),
                        onPressed: (){}
                      ),
                      IconButton(
                        icon: Image.asset(
                          'assets/images/x.png',
                          height: 44,
                          width: 44, 
                          ),
                        onPressed: (){}
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

