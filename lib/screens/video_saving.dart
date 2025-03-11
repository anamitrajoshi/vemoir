import 'dart:ui';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

class VideoSavingWidget extends StatefulWidget {
  final String videoPath;

  VideoSavingWidget({super.key, required this.videoPath});

  @override
  State<VideoSavingWidget> createState() => _VideoSavingWidgetState();
}

class _VideoSavingWidgetState extends State<VideoSavingWidget> {
  VideoPlayerController? _videoController;
  late TextEditingController _tagController;
  late TextEditingController _peopleController;
  List<String> _tags = [];
  List<String> _people = [];

  @override
  void initState() {
    super.initState();
    _tagController = TextEditingController();
    _peopleController = TextEditingController();
    if (widget.videoPath.isNotEmpty) {
      _videoController = VideoPlayerController.file(File(widget.videoPath))
        ..initialize().then((_) {
          setState(() {});
          _videoController?.play();
        });
    }
  }

  @override
  void dispose() {
    _tagController.dispose();
    _peopleController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> saveVideo() async {
    final String apiUrl = 'http://10.0.2.2:8000/videos';
    final String token = 'YOUR_TOKEN_HERE'; // Add valid token here

    final Map<String, dynamic> data = {
      'video_path': widget.videoPath,
      'tags': _tags,
      'people': _people,
      'timestamp': DateTime.now().toIso8601String(),
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Video saved successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save video: ${response.body}')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving video')),
      );
    }
  }

  Future<void> deleteVideo() async {
    final file = File(widget.videoPath);
    if (await file.exists()) {
      await file.delete();
    }
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Video discarded')),
    );
  }

  void _addTag() {
    if (_tagController.text.isNotEmpty) {
      setState(() {
        _tags.add(_tagController.text);
        _tagController.clear();
      });
    }
  }

  void _addPerson() {
    if (_peopleController.text.isNotEmpty) {
      setState(() {
        _people.add(_peopleController.text);
        _peopleController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Color(0xFFEDE7E3),
        appBar: AppBar(
          backgroundColor: Color(0xFFEDE7E3),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Upload Video',
            style: TextStyle(
              fontSize: 22,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          elevation: 2,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              children: [
                // Video Player
                Container(
                  height: 200,
                  child: _videoController != null && _videoController!.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: _videoController!.value.aspectRatio,
                          child: VideoPlayer(_videoController!),
                        )
                      : Center(child: CircularProgressIndicator()),
                ),
                SizedBox(height: 24),

                // Add Tags
                Text('Add tags', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _tagController,
                        decoration: InputDecoration(
                          labelText: 'Tag',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(icon: Icon(Icons.add), onPressed: _addTag),
                  ],
                ),
                Wrap(
                  spacing: 8,
                  children: _tags.map((tag) {
                    return Chip(
                      label: Text(tag),
                      onDeleted: () {
                        setState(() {
                          _tags.remove(tag);
                        });
                      },
                    );
                  }).toList(),
                ),

                // Add People
                SizedBox(height: 24),
                Text('Add people', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _peopleController,
                        decoration: InputDecoration(
                          labelText: 'People',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(icon: Icon(Icons.add), onPressed: _addPerson),
                  ],
                ),
                Wrap(
                  spacing: 8,
                  children: _people.map((person) {
                    return Chip(
                      label: Text(person),
                      onDeleted: () {
                        setState(() {
                          _people.remove(person);
                        });
                      },
                    );
                  }).toList(),
                ),

                // Save and Discard Buttons
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: saveVideo,
                      child: Text('Save', style: TextStyle(fontSize: 18, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF70798C),
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: deleteVideo,
                      child: Text('Discard', style: TextStyle(fontSize: 18, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
