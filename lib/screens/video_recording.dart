import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class VideoRecorderScreen extends StatefulWidget {
  @override
  _VideoRecorderScreenState createState() => _VideoRecorderScreenState();
}

class _VideoRecorderScreenState extends State<VideoRecorderScreen> {
  CameraController? _controller;
  late List<CameraDescription> _cameras;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(_cameras[0], ResolutionPreset.high);
    await _controller!.initialize();
    if (mounted) setState(() {});
  }

  Future<void> _startRecording() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    final directory = await getApplicationDocumentsDirectory();
    final videoPath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.mp4';

    await _controller!.startVideoRecording();
    setState(() => _isRecording = true);
  }

  Future<void> _stopRecording() async {
    if (!_isRecording) return;

    final XFile videoFile = await _controller!.stopVideoRecording();
    final directory = await getApplicationDocumentsDirectory();
    final savedVideoPath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.mp4';

    // Move the recorded video to app storage
    File(videoFile.path).renameSync(savedVideoPath);

    setState(() => _isRecording = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Video saved at: $savedVideoPath')),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Record Video')),
      body: _controller == null || !_controller!.value.isInitialized
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(child: CameraPreview(_controller!)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(_isRecording ? Icons.stop : Icons.videocam, size: 40),
                      color: _isRecording ? Colors.red : Colors.blue,
                      onPressed: _isRecording ? _stopRecording : _startRecording,
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
