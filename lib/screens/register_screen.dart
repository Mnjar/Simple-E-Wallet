import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:projectbncc/screens/home_screen.dart';
import 'package:projectbncc/screens/login_screen.dart';
import 'package:projectbncc/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sign Up",
          style: TextStyle(
              fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Form(
        child: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: SafeArea(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 42.0),
                      TextField(
                        controller: _fullNameController,
                        decoration: InputDecoration(
                          hintText: "Full Name",
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Icon(Icons.person),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24.0),
                              borderSide: BorderSide.none),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          hintText: "Username",
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Icon(Icons.person),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      TextField(
                        controller: _phoneNumberController,
                        decoration: InputDecoration(
                          hintText: "Phone Number",
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Icon(Icons.phone),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: "Email",
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Icon(Icons.email),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Password",
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Icon(Icons.lock),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      TextField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Confirm Password",
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Icon(Icons.lock),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      ElevatedButton(
                        onPressed: () async {
                          final navigator = Navigator.of(context);
                          final scaffoldMessenger =
                              ScaffoldMessenger.of(context);
                          final fullName = _fullNameController.text;
                          final username = _usernameController.text;
                          final password = _passwordController.text;
                          final email = _emailController.text;
                          final phoneNumber = _phoneNumberController.text;
                          final confirmPassword =
                              _confirmPasswordController.text;
                          try {
                            if (password != confirmPassword) {
                              scaffoldMessenger.showSnackBar(const SnackBar(
                                content: Text("Passwords do not match."),
                              ));
                              return;
                            }
                            User? user = await AuthService.createUser(
                                fullName,
                                username,
                                phoneNumber,
                                email,
                                password,
                                password);
                            if (user != null) {
                              scaffoldMessenger.showSnackBar(const SnackBar(
                                content: Text("Registration successful"),
                              ));
                              navigator.pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ),
                              );
                            }
                          } catch (error) {
                            scaffoldMessenger.showSnackBar(SnackBar(
                              content: Text(error.toString()),
                            ));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 134, 90, 254),
                          foregroundColor: Colors.white,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 60.0,
                          ),
                        ),
                        child: const Text(
                          "Register",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 24),
                      RichText(
                        text: TextSpan(
                          text: "Already have an account? ",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                          children: [
                            TextSpan(
                              text: "Login",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                },
                            ),
                          ],
                        ),
                      )
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
