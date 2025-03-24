import 'package:flutter/material.dart';
import 'find_alumni.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const GradBond(), // Your landing page
    );
  }
}

class GradBond extends StatelessWidget {
  const GradBond({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Removed MaterialApp from here
      body: Stack(
        children: [
          // Background image 
          Positioned.fill(
            child: Image.asset(
              'assets/images/landingPage.png',
              fit: BoxFit.fill,
            ),
          ),
          // SingleChildScrollView for scrollable content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // logo
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
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
                        onPressed: () {},
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
                  const SizedBox(height: 60,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Facebook
                      IconButton(
                        icon: Image.asset(
                          'assets/images/facebook.png',
                          height: 48,
                          width: 48,                        
                        ),                                 
                        onPressed: (){},
                      ),
                      //Linkedin
                      IconButton(
                        icon: Image.asset(
                        'assets/images/linkedin.png',
                        height: 32,
                        width: 32, 
                        ),
                        onPressed: (){}
                      ),
                      //X
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

// Widget _buildSearchBar() {
//   return Container(
//     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//     decoration: BoxDecoration(
//       color: Colors.grey[200],
//       borderRadius: BorderRadius.circular(8),
//     ),
//     child: Row(
//       children: [
//         const Icon(Icons.search, color: Colors.blueGrey),
//         const SizedBox(width: 8),
//         Expanded(
//           child: TextField(
//             decoration: const InputDecoration(
//               hintText: 'Search by University | Department | Company | Job Title',
//               border: InputBorder.none, // Remove the underline
//               hintStyle: TextStyle(
//                 color: Colors.grey,
//                 fontSize: 16,
//               ),
//             ),
//             onChanged: (value) {
//               // Handle the text input as the user types
//               print('User typed: $value');
//             },
//             onSubmitted: (value) {
//               // Handle the text input when the user presses "Enter"
//               print('User submitted: $value');
//             },
//           ),
//         ),
//       ],
//     ),
//   );
// }
