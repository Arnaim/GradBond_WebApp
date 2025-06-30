import 'package:flutter/material.dart';
import 'package:gradbond/gradient_bg.dart';
import 'signup_page.dart';
import 'package:gradbond/services/api_service.dart';
import 'home.dart'; 

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{
  final _formKey = GlobalKey<FormState>(); // Key to identify and validate the form
  final _emailController = TextEditingController(); // Controller to get email input
  final _passwordController = TextEditingController(); // Controller to get password input

  @override
  void dispose(){
    // Dispose controllers to free resources when widget is removed
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: GradientBackground(
        child: Padding(
          padding: EdgeInsets.all(24.0), // Padding around content
          child: Center(
            child: SingleChildScrollView( // Enables scrolling if keyboard opens or small screen
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Center contents vertically
                children: [
                  const Text(
                    'Login to continue',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Form containing email and password fields
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Email input field with validation
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText:'Email',
                            labelStyle: TextStyle(
                              color: Color.fromRGBO(116, 116, 117, 1)
                            )
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value){
                            if(value == null || value.isEmpty){
                              return 'Please enter email'; // Show error if empty
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Password input field with obscure text and validation
                        TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              color: Color.fromRGBO(116, 116, 117, 1)
                            )
                          ),
                          obscureText: true, // Hide password input
                          validator: (value){
                            if(value==null || value.isEmpty){
                              return 'Please enter password'; // Show error if empty
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Login button taking full width
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              // Validate form fields
                              if (_formKey.currentState!.validate()) {
                                final email = _emailController.text.trim();
                                final password = _passwordController.text;

                                // Call login API via AuthService
                                final success = await AuthService.login(email, password);

                                if (success) {
                                  // If login successful, navigate to HomePage replacing current page
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) =>  HomePage(),
                                    ),
                                  );
                                } else {
                                  // Show error if login failed
                                  AuthService.showAuthError(context, 'Invalid email or password');
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(58, 29, 111, 1), // Deep purple background
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 1), // White text
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ),

                  const SizedBox(height: 24),

                  // Row with prompt to sign up if no account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          // Navigate to SignUpPage on pressing "Sign up"
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SignUpPage()),
                          );
                        },
                        child: const Text(
                          'Sign up',
                          style: TextStyle(
                            color: Color.fromRGBO(0, 87, 183, 1) // Blue color for sign up text
                          ),
                        )
                      )
                    ],
                  )
                ],
              ),
            )
          ),
        ),
      ),
    );
  }
}
