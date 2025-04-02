/*
## Widget Hierarchy:

SignupPage (StatefulWidget)
└── Scaffold (page skeleton)
    ├── AppBar (top header)
    │   └── Text ('Signup')
    └── SingleChildScrollView (scrollable body)
        └── Padding (content padding)
            └── Form (form container)
                └── Column (vertical layout)
                    ├── SizedBox (spacing)
                    ├── Text ('Create Your Account') (title)
                    ├── SizedBox (spacing)
                    ├── Text ('Select Role') (label)
                    ├── DropdownButtonFormField<String> (role selector)
                    │   └── DropdownMenuItem<String> (options: Student, Alumni)
                    ├── Visibility (Student Fields - Conditional)
                    │   ├── TextFormField (University)
                    │   │   ├── InputDecoration
                    │   │   │   ├── labelText ('University')
                    │   │   │   └── Icon (Icons.school)
                    │   ├── TextFormField (Department)
                    │   │   ├── InputDecoration
                    │   │   │   ├── labelText ('Department')
                    │   │   │   └── Icon (Icons.business)
                    │   ├── TextFormField (Student ID)
                    │   │   ├── InputDecoration
                    │   │   │   ├── labelText ('Student ID')
                    │   │   │   └── Icon (Icons.badge)
                    ├── TextFormField (Email)
                    │   ├── InputDecoration
                    │   │   ├── labelText ('Email')
                    │   │   └── Icon (Icons.email)
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
    
    User->>UI: Selects Role from Dropdown
    UI->>State: Updates Visibility of Student Fields (if Student)
    
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
            alt Role == Student
                UI->>Navigation: pushReplacementNamed('/login')
            else Role == Alumni
                UI->>Navigation: pushReplacementNamed('/alumni_verification')
            end
            UI->>User: Shows success snackbar
        else Error
            Server-->>State: Error response
            State->>UI: setState(_isLoading=false)
            UI->>User: Shows error snackbar
        end
    else Invalid Fields
        UI->>User: Shows field errors
    end
    
    User->>UI: Clicks "Already have account?"
    UI->>Navigation: pushReplacementNamed('/login')
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
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
      await Future.delayed(const Duration(seconds: 2));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully!')),
      );
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
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
      body: SingleChildScrollView(
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
                child:
                    _isLoading
                        ? CircularProgressIndicator()
                        : const Text('Signup'),
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
