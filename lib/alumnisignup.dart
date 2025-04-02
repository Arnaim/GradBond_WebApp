/*
## Widget Hierarchy:

AlumniSignupPage (StatefulWidget)
└── Scaffold (page structure)
    ├── AppBar (top header)
    │   └── Text ('Alumni Signup')
    └── SingleChildScrollView (scrollable body)
        └── Padding (content padding)
            └── Form (form container)
                └── Column (vertical layout)
                    ├── SizedBox (spacing)
                    ├── Text ('Register as Alumni') (title)
                    ├── SizedBox (spacing)
                    ├── TextFormField (Full Name)
                    │   ├── InputDecoration
                    │   │   ├── labelText ('Full Name')
                    │   │   └── Icon (Icons.person)
                    ├── TextFormField (Email)
                    │   ├── InputDecoration
                    │   │   ├── labelText ('Email')
                    │   │   └── Icon (Icons.email)
                    ├── TextFormField (Phone Number)
                    │   ├── InputDecoration
                    │   │   ├── labelText ('Phone Number')
                    │   │   └── Icon (Icons.phone)
                    ├── TextFormField (Graduation Year)
                    │   ├── InputDecoration
                    │   │   ├── labelText ('Graduation Year')
                    │   │   └── Icon (Icons.calendar_today)
                    ├── TextFormField (Department)
                    │   ├── InputDecoration
                    │   │   ├── labelText ('Department')
                    │   │   └── Icon (Icons.business)
                    ├── TextFormField (Password)
                    │   ├── InputDecoration
                    │   │   ├── labelText ('Password')
                    │   │   ├── Icon (Icons.lock)
                    │   │   └── IconButton (visibility toggle)
                    ├── TextFormField (Confirm Password)
                    │   ├── InputDecoration
                    │   │   ├── labelText ('Confirm Password')
                    │   │   ├── Icon (Icons.lock_outline)
                    │   │   └── IconButton (visibility toggle)
                    ├── CheckboxListTile (Agree to Terms & Conditions)
                    │   ├── Checkbox
                    │   └── Text ('I agree to the terms and conditions')
                    ├── ElevatedButton (Signup)
                    │   └── Conditional Child:
                    │       ├── CircularProgressIndicator (loading state)
                    │       └── Text ('Signup') (normal state)
                    └── TextButton (Login link)
                        └── Text.rich
                            ├── TextSpan ('Already have an account?')
                            └── TextSpan ('Login', bold+blue)

## Visual Execution Flow: 

sequenceDiagram
    participant User
    participant UI
    participant State
    participant Navigation
    
    User->>UI: Fills form fields
    User->>UI: Clicks Signup button
    UI->>State: validate()
    State-->>UI: Shows errors if any
    
    alt All Valid
        UI->>State: setState(_isLoading=true)
        UI->>State: Shows loading spinner
        State->>Server: Simulated API call (2s delay)
        
        alt Success
            Server-->>State: Success response
            State->>UI: setState(_isLoading=false)
            UI->>User: Shows success snackbar
            UI->>Navigation: pushReplacementNamed('/alumni_dashboard')
        else Error
            Server-->>State: Error response
            State->>UI: setState(_isLoading=false)
            UI->>User: Shows error snackbar
        end
    else Invalid Fields
        UI->>User: Shows field errors
    end
    
    User->>UI: Clicks "Already have an account?"
    UI->>Navigation: pushReplacementNamed('/login')
*/


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AlumniSignupPage extends StatefulWidget {
  const AlumniSignupPage({Key? key}) : super(key: key);

  @override
  _AlumniSignupPageState createState() => _AlumniSignupPageState();
}

class _AlumniSignupPageState extends State<AlumniSignupPage> {
  final _formKey = GlobalKey<FormState>();
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

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
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

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 2));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully!')),
      );
      Navigator.pushReplacementNamed(context, '/login');
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
        title: const Text('Alumni Signup Portal'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 20 : size.width * 0.2, 
          vertical: 20
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
              const Text('I am a/an Alumni', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
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
                    : const Text('Signup', style: TextStyle(fontSize: 16)),
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