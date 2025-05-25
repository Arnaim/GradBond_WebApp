//login screen
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
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


@override
Widget build(BuildContext context){
  return Scaffold(
    body: GradientBackground(
      child: Padding(padding: EdgeInsets.all(24.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Login to continue',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32,),
              Form(
                key: _formKey,
                child: Column(
                  children: [
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
                          return 'Please enter email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16,),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          color: Color.fromRGBO(116, 116, 117, 1)
                         )
                      ),
                      obscureText: true,
                      validator: (value){
                        if(value==null || value.isEmpty){
                          return 'Please enter password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24,),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                      onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                  final email = _emailController.text.trim();
                                  final password = _passwordController.text;

                                  final success = await AuthService.login(email, password);

                              if (success) {
                                  Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                // Changed from FindAlumni to HomePage
                                   builder: (context) =>  HomePage(),
                               ),
                              );
                             } else {
                               AuthService.showAuthError(context, 'Invalid email or password');
                           }
                         }
                      },
                        style:  ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(58, 29, 111, 1), 
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1)
                          ),
                          ),
                        ),
                    )
                  ],
                )
                ),
                const SizedBox(height: 24,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                       onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SignUpPage()),
                            );
                          },
                      child: const Text(
                        'Sign up',
                        style: TextStyle(
                          color: Color.fromRGBO(0, 87, 183, 1)
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
  )
  );
}
}