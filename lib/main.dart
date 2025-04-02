/*
## Widget Hierarchy:

MyApp (StatelessWidget)
└── MaterialApp (root application)
    ├── title: 'Student Portal'
    ├── theme: ThemeData
    │   ├── primarySwatch: Colors.blue
    │   ├── visualDensity: adaptivePlatformDensity
    │   ├── inputDecorationTheme
    │   │   ├── border: OutlineInputBorder (rounded corners)
    │   │   ├── contentPadding: EdgeInsets.symmetric (15, 15)
    │   ├── elevatedButtonTheme
    │   │   ├── padding: EdgeInsets.symmetric (vertical: 15)
    │   │   ├── shape: RoundedRectangleBorder (borderRadius 10)
    ├── initialRoute: '/signup' (starting page)
    ├── routes: (Named Routes)
    │   ├── '/signup' -> SignupPage
    │   ├── '/login' -> LoginPage
    │   ├── '/alumni-signup' -> AlumniSignupPage
    └── debugShowCheckedModeBanner: false (hides debug banner)


## Visual Execution Flow: 

sequenceDiagram
    participant System
    participant MyApp
    participant UI
    participant Navigation
    
    System->>MyApp: Launches Application
    MyApp->>UI: Loads MaterialApp with ThemeData
    
    alt First Launch
        UI->>Navigation: Sets initialRoute to '/signup'
        Navigation->>SignupPage: Displays Signup Screen
    end
    
    User->>UI: Navigates between routes
    UI->>Navigation: pushReplacementNamed('/login') on Login tap
    UI->>Navigation: pushReplacementNamed('/signup') on Signup tap
    UI->>Navigation: pushReplacementNamed('/alumni-signup') if user selects alumni
*/





import 'package:flutter/material.dart';
import 'signup.dart';
import 'login.dart';
import 'alumnisignup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Portal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      initialRoute: '/signup',
      routes: {
        '/signup': (context) => const SignupPage(),
        '/login': (context) => const LoginPage(),
        '/alumni-signup': (context) => const AlumniSignupPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

