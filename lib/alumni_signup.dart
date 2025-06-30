import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradbond/gradient_bg.dart';
import 'auth_service.dart';

class AlumniSignup extends StatefulWidget {
  const AlumniSignup({super.key});

  @override
  _AlumniSignupPageState createState() => _AlumniSignupPageState();
}

class _AlumniSignupPageState extends State<AlumniSignup> {
  // Key to identify and validate the form
  final _formKey = GlobalKey<FormState>();

  // Controllers for each text input field
  final _universityController = TextEditingController();
  final _departmentController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _graduationYearController = TextEditingController();
  final _companyController = TextEditingController();
  final _jobTitleController = TextEditingController();
  final _linkedinController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Default user type
  String? _userType = 'Alumni';

  // Loading state for the signup process
  bool _isLoading = false;

  // Controls for password visibility toggling
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    // Dispose all controllers to free resources when widget is removed
    _universityController.dispose();
    _departmentController.dispose();
    _studentIdController.dispose();
    _emailController.dispose();
    _graduationYearController.dispose();
    _companyController.dispose();
    _jobTitleController.dispose();
    _linkedinController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Function to handle form submission
  Future<void> _submitForm() async {
    // Validate all form fields; return early if any invalid
    if (!_formKey.currentState!.validate()) return;

    // Show loading spinner while processing
    setState(() => _isLoading = true);

    try {
      // Extract email and password from form
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      // Call API function to create account with email & password
      final success = await AuthService.signUp(email, password);

      if (success) {
        // On success, show message and navigate to login page
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created successfully!')),
        );
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        // If email already exists, show error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email already exists')),
        );
      }
    } catch (e) {
      // If error occurs during signup, display error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      // Hide loading spinner once done
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Responsive padding: smaller for small screens, wider for larger screens
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alumni Signup Portal'),
        centerTitle: true,
      ),
      body: GradientBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 20 : size.width * 0.2,
              vertical: 20,
            ),
            child: Form(
              key: _formKey, // Attach form key for validation
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),

                  // Title text
                  const Text(
                    'Create a new Account',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),

                  // User type label
                  const Text('I am a/an Alumni', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),

                  // Dropdown to select user type (Student or Alumni)
                  DropdownButtonFormField<String>(
                    value: _userType,
                    items: ['Student', 'Alumni']
                        .map(
                          (role) => DropdownMenuItem(value: role, child: Text(role)),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() => _userType = value);
                      // If Alumni selected, reload Alumni Signup page (may be redundant)
                      if (value == 'Alumni') {
                        Navigator.pushReplacementNamed(context, '/alumni-signup');
                      }
                    },
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // University input field
                  TextFormField(
                    controller: _universityController,
                    decoration: const InputDecoration(
                      labelText: 'University',
                      prefixIcon: Icon(Icons.school),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter your university';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Department input field
                  TextFormField(
                    controller: _departmentController,
                    decoration: const InputDecoration(
                      labelText: 'Department',
                      prefixIcon: Icon(Icons.business),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter your department';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Student ID input field (digits only)
                  TextFormField(
                    controller: _studentIdController,
                    decoration: const InputDecoration(
                      labelText: 'Student ID',
                      prefixIcon: Icon(Icons.badge),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter your student ID';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Email input field with regex validation
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter your email';
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Graduation year input (digits only)
                  TextFormField(
                    controller: _graduationYearController,
                    decoration: const InputDecoration(
                      labelText: 'Graduation Year',
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter your graduation year';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Company input field
                  TextFormField(
                    controller: _companyController,
                    decoration: const InputDecoration(
                      labelText: 'Company',
                      prefixIcon: Icon(Icons.business_center),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter your company';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Job title input field
                  TextFormField(
                    controller: _jobTitleController,
                    decoration: const InputDecoration(
                      labelText: 'Job Title',
                      prefixIcon: Icon(Icons.work),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter your job title';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // LinkedIn URL input field
                  TextFormField(
                    controller: _linkedinController,
                    decoration: const InputDecoration(
                      labelText: 'LinkedIn URL',
                      prefixIcon: Icon(Icons.link),
                    ),
                    keyboardType: TextInputType.url,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter your LinkedIn URL';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Password input with visibility toggle
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
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter a password';
                      if (value.length < 8) return 'Password must be at least 8 characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Confirm password input with visibility toggle
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                      ),
                    ),
                    obscureText: _obscureConfirmPassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please confirm your password';
                      if (value != _passwordController.text) return 'Passwords do not match';
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),

                  // Signup button - calls _submitForm on press
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(58, 29, 111, 1),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : const Text(
                            'Signup',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                  ),
                  const SizedBox(height: 20),

                  // Link to navigate to login page if user already has an account
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: const Text.rich(
                        TextSpan(
                          text: 'Already have an account? ',
                          children: [
                            TextSpan(
                              text: 'Login',
                              style: TextStyle(color: Color.fromRGBO(0, 87, 183, 1)),
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
        ),
      ),
    );
  }
}
