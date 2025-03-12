import 'package:flutter/material.dart';
import 'home.dart';
import 'login.dart';
import 'signup.dart';
import 'user_profile.dart';
import 'video_library.dart';
import 'video_saving.dart';

class NavigationPage extends StatelessWidget {
  const NavigationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation Page'),
        backgroundColor: const Color(0xFF162d3a), 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildNavigationButton(context, 'Home', const HomeWidget(userId: '1')),
            _buildNavigationButton(context, 'Login', const LoginPage()),
            _buildNavigationButton(context, 'Sign Up', const SignUpPage()),
            _buildNavigationButton(context, 'Video Library', const VideoLibraryWidget(userId: '1',)),
          
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButton(BuildContext context, String title, Widget destinationPage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destinationPage),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF162d3a), // Button background color
          padding: const EdgeInsets.symmetric(vertical: 16), // Button size
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
