import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

final String backendUrl = "http://10.0.2.2:8000"; // Use the same IP as login

Future<void> _signUp() async {
  if (_passwordController.text != _confirmPasswordController.text) {
    _showMessage("Passwords do not match", Colors.red);
    return;
  }

  try {
    final response = await http.post(
      Uri.parse("$backendUrl/users"),  // Use "signup" instead of "signin" if needed
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": _nameController.text,
        "email": _emailController.text,
        "password": _passwordController.text
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      _showMessage("Sign Up Successful!", Colors.green);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
    } else {
      _showMessage(responseData['message'] ?? "Signup failed", Colors.red);
    }
  } catch (e) {
    print("Error: $e");
    _showMessage("An error occurred: $e", Colors.red);
  }
}


  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1ED),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Create Account',
                style: GoogleFonts.outfit(fontSize: 30, color: const Color(0xFF162D3A), fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Start your video journaling journey',
                style: GoogleFonts.outfit(fontSize: 16, color: Colors.grey[700]!, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 24),
              Container(
                width: 400,
                padding: const EdgeInsets.all(32.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 208, 196, 182),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(controller: _nameController, decoration: _inputDecoration("Display Name")),
                    const SizedBox(height: 16),
                    TextField(controller: _emailController, decoration: _inputDecoration("Email Address")),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: _passwordDecoration("Password", _isPasswordVisible, () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      }),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: !_isConfirmPasswordVisible,
                      decoration: _passwordDecoration("Confirm Password", _isConfirmPasswordVisible, () {
                        setState(() {
                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                        });
                      }),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: 336,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _signUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF162D3A),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                        ),
                        child: Text('Sign Up', style: GoogleFonts.outfit(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account?", style: GoogleFonts.outfit(fontSize: 16, color: Colors.grey[800], fontWeight: FontWeight.w500)),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                          },
                          child: Text("Log In", style: GoogleFonts.outfit(fontSize: 16, color: const Color(0xFF162D3A), fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(labelText: label, border: const OutlineInputBorder());
  }

  InputDecoration _passwordDecoration(String label, bool isVisible, VoidCallback toggleVisibility) {
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      suffixIcon: IconButton(
        icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
        onPressed: toggleVisibility,
      ),
    );
  }
}
