import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'screens/video_recording.dart';
import 'screens/demo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await requestPermissions(); 
  runApp(const MyApp());
}

Future<void> requestPermissions() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.camera,
    Permission.microphone,
    Permission.storage, 
    Permission.photos,  
  ].request();

  if (statuses[Permission.camera]!.isDenied ||
      statuses[Permission.microphone]!.isDenied ||
      statuses[Permission.storage]!.isDenied ||
      statuses[Permission.photos]!.isDenied) {
    print("Some permissions were denied.");
  }


  if (statuses[Permission.camera]!.isPermanentlyDenied ||
      statuses[Permission.microphone]!.isPermanentlyDenied ||
      statuses[Permission.storage]!.isPermanentlyDenied ||
      statuses[Permission.photos]!.isPermanentlyDenied) {
    print("Some permissions are permanently denied. Open app settings.");
    openAppSettings(); 
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xfff5f1ed)),
        useMaterial3: true,
      ),
      home: NavigationPage(),
    );
  }
}
