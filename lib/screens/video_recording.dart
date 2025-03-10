import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'video_saving.dart'; 

class VideoRecorderScreen extends StatefulWidget {
  @override
  _VideoRecorderScreenState createState() => _VideoRecorderScreenState();
}

class _VideoRecorderScreenState extends State<VideoRecorderScreen> {
  CameraController? _controller;
  late List<CameraDescription> _cameras;
  bool _isRecording = false;
  VideoPlayerController? _videoPlayerController;
  int _selectedCameraIdx = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(
      _cameras[_selectedCameraIdx],
      ResolutionPreset.high,
      enableAudio: true,
    );

    await _controller!.initialize();
    await _controller!.lockCaptureOrientation(DeviceOrientation.portraitUp);

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _startRecording() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    await _controller!.startVideoRecording();
    setState(() => _isRecording = true);
  }


Future<void> _stopRecording() async {
  if (!_isRecording) return;

  final XFile videoFile = await _controller!.stopVideoRecording();
  final directory = await getApplicationDocumentsDirectory();
  final savedVideoPath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.mp4';

  File(videoFile.path).copySync(savedVideoPath);
  final prefs = await SharedPreferences.getInstance();
final saveSuccess = await prefs.setString('last_video_path', savedVideoPath);

if (saveSuccess) {  
  print('Video path saved successfully: $savedVideoPath');
  
  setState(() => _isRecording = false);

 Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => VideoSavingWidget(videoPath: savedVideoPath),
  ),
);

} else {
  print('Failed to save video path.');
}


  // _playRecordedVideo(savedVideoPath);
}

  void _playRecordedVideo(String path) {
    if (_videoPlayerController != null) {
      _videoPlayerController!.dispose();
    }

    _videoPlayerController = VideoPlayerController.file(File(path))
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController!.setLooping(true);
        _videoPlayerController!.play();
      });
  }

  void _switchCamera() {
    if (_cameras.length <= 1) return;

    _selectedCameraIdx = (_selectedCameraIdx + 1) % _cameras.length;

    if (_controller != null) {
      _controller!.dispose();
    }

    _initializeCamera();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Scaffold(
        appBar: AppBar(title: Text('Record Video')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Video Recorder'),
        actions: [
          IconButton(
            icon: Icon(Icons.flip_camera_ios),
            onPressed: _switchCamera,
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _videoPlayerController != null && _videoPlayerController!.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _videoPlayerController!.value.aspectRatio,
                    child: VideoPlayer(_videoPlayerController!),
                  )
                : Container(
                    width: size.width,
                    height: size.width * 16 / 9,
                    child: ClipRect(
                      child: OverflowBox(
                        alignment: Alignment.center,
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Container(
                            width: size.width,
                            height: size.width / _controller!.value.aspectRatio,
                            child: Transform(
  alignment: Alignment.center,
  transform: Matrix4(
    0.0, -1.0, 0.0, 0.0,  
   1.0, 0.0, 0.0, 0.0,  
    0.0, 0.0, 1.0, 0.0,  
    0.0, 0.0, 0.0, 1.0   
  ),
  child: CameraPreview(_controller!),
),

                          ),
                        ),
                      ),
                    ),
                  ),
          ),
          Container(
            color: Colors.black,
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  backgroundColor: _isRecording ? Colors.red : Colors.blue,
                  child: Icon(
                    _isRecording ? Icons.stop : Icons.videocam,
                    size: 36,
                  ),
                  onPressed: _isRecording ? _stopRecording : _startRecording,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
