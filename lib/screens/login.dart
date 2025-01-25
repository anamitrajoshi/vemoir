import 'package:flutter/material.dart';
import 'signup.dart'; // Import the SignUpPage

// Helper function to define a TextStyle
TextStyle headingStyle(double fontSize, Color color, FontWeight fontWeight) {
  return TextStyle(
    fontSize: fontSize,
    color: color,
    fontWeight: fontWeight,
  );
}

// Helper function to define a TextStyle for labels
TextStyle labelStyle() {
  return const TextStyle(
    fontSize: 16.0,
  );
}

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA99985), // Background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'VEMOIR',
              style: headingStyle(45, Colors.white, FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Container(
              width: 400, // Adjust width as needed
              padding: const EdgeInsets.all(32.0),
              decoration: BoxDecoration(
                color: const Color(0xFFf5f1ed), // Box color
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
                children: <Widget>[
                  Text(
                    'Log In',
                    style: headingStyle(24, Colors.black, FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: labelStyle(),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: labelStyle(),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      // Handle login logic here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF162d3a), // Button background color
                      foregroundColor: Colors.white, // Text color
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15), // Increase size
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0), // Rounded corners
                      ),
                    ),
                    child: const Text(
                      'Log In',
                      style: TextStyle(fontSize: 18), // Slightly larger text size
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Or sign in with',
                    style: labelStyle(),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Handle Google login logic here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Google'),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          // Navigate to the Sign Up page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpPage(),
                            ),
                          );
                        },
                        child: const Text('Sign Up'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: LoginPage(),
  ));
}
