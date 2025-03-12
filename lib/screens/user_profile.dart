import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

void _logout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const LoginPage()),
    (route) => false,
  );
}

class ProfilePage extends StatefulWidget {
  final String id;

  const ProfilePage({Key? key, required this.id}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? name;
  String? username;
  String? profilePicture;
  int? streak;
  int? videos;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/users/${widget.id}'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      setState(() {
        name = data['name'];
        username = data['username'];
        profilePicture = data['profile_picture'] ?? 'https://via.placeholder.com/100';
        streak = data['streak'] ?? 0;
        videos = data['videos'] ?? 0;
        _nameController.text = name ?? '';
        _usernameController.text = username ?? '';
      });
    } else {
      print('Failed to load user data');
    }
  }

  Future<void> saveProfile() async {
    final String apiUrl = 'http://10.0.2.2:8000/users/${widget.id}';

    final Map<String, dynamic> data = {
      'name': name,
      'username': username,
      'profile_picture': profilePicture,
    };

    try {
      final response = await http.patch(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        print('Profile updated successfully!');
      } else {
        print('Failed to update profile: ${response.body}');
      }
    } catch (e) {
      print('Error updating profile: $e');
    }
  }

Future<void> _updateProfilePicture() async {
  final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  
  if (pickedFile != null) {
    List<int> imageBytes = await File(pickedFile.path).readAsBytes();
    String base64Image = base64Encode(imageBytes);

    setState(() {
      profilePicture = base64Image; 
    });

    saveProfile(); 
  }
}

  void _editName() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Name'),
          content: TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  name = _nameController.text;
                });
                saveProfile(); // Save updated name
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _editUsername() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Username'),
          content: TextField(
            controller: _usernameController,
            decoration: const InputDecoration(labelText: 'Username'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  username = _usernameController.text;
                });
                saveProfile(); // Save updated username
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOptionTile(BuildContext context, IconData icon, String title) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(icon, color: const Color(0xFF70798C), size: 24),
            const SizedBox(width: 12),
            Material(
              color: Colors.transparent,
              child: Text(
                title,
                style: const TextStyle(fontFamily: 'Inter', fontSize: 16, color: Color(0xFF70798C)),
              ),
            ),
          ],
        ),
      ],
    );
  }

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              GestureDetector(
                onTap: _updateProfilePicture,
                child: Material(
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
                      child: profilePicture != null
                          ? Image.file(
                              File(profilePicture!),
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.person, size: 50),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(name ?? 'Loading...', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: _editName),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('@${username ?? 'Loading...'}', style: const TextStyle(fontFamily: 'Inter', color: Colors.grey)),
                      IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: _editUsername),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

             _buildOptionTile(context, Icons.settings, 'Settings'),
                    const SizedBox(height: 16),
                    _buildOptionTile(context, Icons.notifications, 'Notifications'),
                    const SizedBox(height: 16),
                    _buildOptionTile(context, Icons.privacy_tip, 'Privacy'),
                    const SizedBox(height: 24),
                    // Logout and Delete Account
                    _buildDangerTile(context, Icons.logout, 'Log Out', Colors.redAccent,   () => _logout(context)),
            ],
          ),
        ),
      ),
    );
  }
}
