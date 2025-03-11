import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

class VideoDisplayWidget extends StatefulWidget {
  final String id;

  const VideoDisplayWidget({super.key, required this.id});

  @override
  State<VideoDisplayWidget> createState() => _VideoDisplayWidgetState();
}

class _VideoDisplayWidgetState extends State<VideoDisplayWidget> {
  VideoPlayerController? _videoController;
  List<String> _tags = [];
  List<String> _people = [];
  String _videoPath = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchVideoDetails();
  }

  Future<void> _fetchVideoDetails() async {
    final String apiUrl = 'http://10.0.2.2:8000/videos/${widget.id}';
    final String token = 'YOUR_TOKEN_HERE'; // Add valid token here

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _videoPath = data['video_path'];
          _tags = List<String>.from(data['tags']);
          _people = List<String>.from(data['people']);
          _initializeVideo();
          _isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load video details')),
        );
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching video details')),
      );
      setState(() => _isLoading = false);
    }
  }

  void _initializeVideo() {
    if (_videoPath.isNotEmpty) {
      _videoController = VideoPlayerController.file(File(_videoPath))
        ..initialize().then((_) {
          setState(() {});
          _videoController?.play();
        });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDE7E3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEDE7E3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'View Video',
          style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Video Player
                   Container(
  height: 200,
  width: double.infinity,
  decoration: BoxDecoration(
    color: Colors.black,
    borderRadius: BorderRadius.circular(12),
  ),
  child: _videoController != null && _videoController!.value.isInitialized
      ? ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: FittedBox(
            fit: BoxFit.cover, 
            child: SizedBox(
              width: _videoController!.value.size.width,
              height: _videoController!.value.size.height,
              child: VideoPlayer(_videoController!),
            ),
          ),
        )
      : const Center(child: CircularProgressIndicator()),
),

                    const SizedBox(height: 24),

                    // Tags Section
                    const Text(
                      'Tags',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    Wrap(
                      spacing: 8,
                      children: _tags.map((tag) {
                        return Chip(
                          label: Text(tag),
                          backgroundColor: const Color(0xFF70798C),
                          labelStyle: const TextStyle(color: Colors.white),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // People Section
                    const Text(
                      'People',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    Wrap(
                      spacing: 8,
                      children: _people.map((person) {
                        return Chip(
                          label: Text(person),
                          backgroundColor: Colors.blueGrey,
                          labelStyle: const TextStyle(color: Colors.white),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),

                    // Play/Pause Button
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (_videoController!.value.isPlaying) {
                              _videoController?.pause();
                            } else {
                              _videoController?.play();
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF70798C),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          _videoController?.value.isPlaying ?? false ? 'Pause' : 'Play',
                          style: const TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
