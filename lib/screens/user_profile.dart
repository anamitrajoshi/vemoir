import 'package:flutter/material.dart';
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';

void _logout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('token'); // Remove stored token
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const LoginPage()),
    (route) => false, // Clears the navigation stack
  );
}

class ProfilePage extends StatelessWidget {
  Widget _buildOptionTile(BuildContext context, IconData icon, String title) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(
              icon,
              color: const Color(0xFF70798C),
              size: 24,
            ),
            const SizedBox(width: 12),
            Material(
              color: Colors.transparent,
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: const Color(0xFF70798C),
                  letterSpacing: 0.0,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Danger Tile Method (for logout, delete account)
Widget _buildDangerTile(BuildContext context, IconData icon, String title, Color color, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Material(
              color: Colors.transparent,
              child: Text(
                title,
                style: TextStyle(fontFamily: 'Inter', fontSize: 16, color: color),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            // Gradient Background
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.surface,
                    Theme.of(context).colorScheme.surface
                  ],
                  stops: [0, 1],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Profile Picture
                    Material(
                      color: Colors.transparent,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60),
                      ),
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(60),
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.network(
                            'https://images.unsplash.com/photo-1638174267779-5fcd54afe356?w=500&h=500',
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    // Name and Username
                    SizedBox(height: 16),
                    Column(
                      children: [
                        Text(
                          'idk', 
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '@mindfuljourney', 
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: Colors.grey,
                            letterSpacing: 0.0,
                          ),
                        ),
                      ],
                    ),
                    // Day Streak and Videos Section
                    SizedBox(height: 24),
                    Material(
                      color: Colors.transparent,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Color(0xa99985),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              // Day Streak Column
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '47',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                  Text(
                                    'Day Streak',
                                    style: TextStyle(fontSize: 16, color: Colors.white),
                                  ),
                                ],
                              ),
                              // Divider Between Streak and Videos
                              Container(
                                width: 1,
                                height: 40, // Fixed height for divider
                                color: Colors.white.withOpacity(0.3),
                              ),
                              // Videos Column
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '156',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                  Text(
                                    'Videos',
                                    style: TextStyle(fontSize: 16, color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Settings
                    _buildOptionTile(context, Icons.settings, 'Settings'),
                    const SizedBox(height: 16),
                    _buildOptionTile(context, Icons.notifications, 'Notifications'),
                    const SizedBox(height: 16),
                    _buildOptionTile(context, Icons.privacy_tip, 'Privacy'),
                    const SizedBox(height: 24),
                    // Logout and Delete Account
                    _buildDangerTile(context, Icons.logout, 'Log Out', Colors.redAccent,   () => _logout(context)),
                    // const SizedBox(height: 16),
                    // _buildDangerTile(context, Icons.delete_forever, 'Delete Account', Colors.red),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
