import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradbond/gradient_bg.dart';
import 'auth_service.dart';

class StudentSignup  extends StatefulWidget {
  const StudentSignup ({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<StudentSignup > {
  final _formKey = GlobalKey<FormState>();
  final _universityController = TextEditingController();
  final _departmentController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _userType = 'Student'; // Default to Student
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _universityController.dispose();
    _departmentController.dispose();
    _studentIdController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _isLoading = true);

  try {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    
    final success = await AuthService.signUp(email, password);
    
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully!')),
      );
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email already exists')),
      );
    }         
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
      appBar: AppBar(title: const Text('Student Signup'), centerTitle: true),
      body: GradientBackground( 
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 20 : size.width * 0.2,
          vertical: 20,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Create a new Account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              const Text('I am a/an', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _userType,
                items:
                    ['Student', 'Alumni']
                        .map(
                          (role) =>
                              DropdownMenuItem(value: role, child: Text(role)),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() => _userType = value);

                  // Navigate to Alumni Signup page if 'Alumni' is selected
                  if (value == 'Alumni') {
                    Navigator.pushReplacementNamed(context, '/alumni-signup');
                  }
                },
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _universityController,
                decoration: const InputDecoration(
                  labelText: 'University',
                  prefixIcon: Icon(Icons.school),
                ),
                validator:
                    (value) =>
                        value!.isEmpty ? 'Please enter your university' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _departmentController,
                decoration: const InputDecoration(
                  labelText: 'Department',
                  prefixIcon: Icon(Icons.business),
                ),
                validator:
                    (value) =>
                        value!.isEmpty ? 'Please enter your department' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _studentIdController,
                decoration: const InputDecoration(
                  labelText: 'Student ID',
                  prefixIcon: Icon(Icons.badge),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator:
                    (value) =>
                        value!.isEmpty ? 'Please enter your student ID' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email'; // Ensures email is not empty
                  }

                  // Fixed regex pattern: removed '\$' at the end and improved validation
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$',
                  ).hasMatch(value)) {
                    return 'Please enter a valid email'; // Ensures valid email format
                  }

                  return null; // Returns null if validation passes
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed:
                        () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                  ),
                ),
                obscureText: _obscurePassword,
                validator:
                    (value) =>
                        value!.length < 8
                            ? 'Password must be at least 8 characters'
                            : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed:
                        () => setState(
                          () =>
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword,
                        ),
                  ),
                ),
                obscureText: _obscureConfirmPassword,
                validator:
                    (value) =>
                        value != _passwordController.text
                            ? 'Passwords do not match'
                            : null,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style:  ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(58, 29, 111, 1), 
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                child:
                    _isLoading
                        ? CircularProgressIndicator()
                        : const Text('Signup', style: TextStyle(
                          color: Colors.white,
                        ),),
              ),
              const SizedBox(height: 20),
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
                          style: TextStyle(
                            color: Color.fromRGBO(0, 87, 183, 1)
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
    )
   );
  }
}