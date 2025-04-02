/*
## Widget Hierarchy:

Scaffold
├── AppBar
└── Body
    └── SingleChildScrollView
        └── Form
            ├── Logo
            ├── Title
            ├── Email Field
            ├── Password Field
            ├── Remember Me
            ├── Login Button
            └── Signup Link


## Visual Execution Flow: 

sequenceDiagram
    User->>UI: Enters credentials
    User->>UI: Clicks Login
    UI->>Validation: Checks form
    Validation-->>UI: Returns status
    alt Valid
        UI->>API: Submit (simulated)
        API-->>UI: Success/Error
        UI->>User: Shows feedback
        alt Success
            UI->>Navigation: Go to home
        end
    else Invalid
        UI->>User: Shows errors
    end
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Simulate network call
      await Future.delayed(const Duration(seconds: 2));
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful!')),
      );

      // Navigate to home page
      // Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Portal'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 20 : size.width * 0.3, 
          vertical: 20
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              const FlutterLogo(size: 100),
              const SizedBox(height: 30),
              const Text(
                'Welcome Back!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Sign in to continue',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter your email';
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submitForm(),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter your password';
                  if (value.length < 8) return 'Password must be at least 8 characters';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) => setState(() => _rememberMe = value ?? false),
                      ),
                      const Text('Remember me'),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigator.pushNamed(context, '/forgot-password');
                    },
                    child: const Text('Forgot Password?'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : const Text('Login', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 30),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/signup');
                  },
                  child: const Text.rich(
                    TextSpan(
                      text: "Don't have an account? ",
                      children: [
                        TextSpan(
                          text: 'Sign up',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}