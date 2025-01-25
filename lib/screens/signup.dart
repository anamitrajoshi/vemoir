import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Method for heading text styles
  TextStyle headingStyle(double fontSize, Color color, FontWeight fontWeight) {
    return GoogleFonts.outfit(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
    );
  }

  // Method for label text styles
  TextStyle labelStyle() {
    return GoogleFonts.outfit(
      fontSize: 16,
      color: Colors.grey[800],
      fontWeight: FontWeight.w500,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1ED),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Page Title
                  Text(
                    'Create Account',
                    style: headingStyle(30, const Color(0xFF162D3A), FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  // Subtitle
                  Text(
                    'Start your video journaling journey',
                    style: headingStyle(16, Colors.grey[700]!, FontWeight.normal),
                  ),
                  const SizedBox(height: 24),
                  // Form Container
                  Container(
                    width: 400,
                    padding: const EdgeInsets.all(32.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 208, 196, 182),
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 16),
                        // Display Name Field
                        SizedBox(
                          width: 336,
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Display Name',
                              labelStyle: labelStyle(),
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Email Field
                        SizedBox(
                          width: 336,
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Email Address',
                              labelStyle: labelStyle(),
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Password Field
                        SizedBox(
                          width: 336,
                          child: TextField(
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: labelStyle(),
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                                icon: Icon(
                                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Confirm Password Field
                        SizedBox(
                          width: 336,
                          child: TextField(
                            obscureText: !_isConfirmPasswordVisible,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              labelStyle: labelStyle(),
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                  });
                                },
                                icon: Icon(
                                  _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Sign Up Button
                        SizedBox(
                          width: 336,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              // Sign-up logic here
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF162D3A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Text(
                              'Sign Up',
                              style: headingStyle(18, Colors.white, FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Already have an account
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account?",
                              style: labelStyle(),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ),
                                );
                              },
                              child: Text(
                                'Log In',
                                style: headingStyle(
                                  16,
                                  const Color(0xFF162D3A),
                                  FontWeight.bold,
                                ),
                              ),
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
        ),
      ),
    );
  }
}
