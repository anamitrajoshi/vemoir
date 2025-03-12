import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'video_display.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'dart:io';
import 'dart:math';
import 'package:intl/intl.dart';

class VideoLibraryWidget extends StatefulWidget {
  const VideoLibraryWidget({Key? key}) : super(key: key);

  @override
  State<VideoLibraryWidget> createState() => _VideoLibraryWidgetState();
}

class _VideoLibraryWidgetState extends State<VideoLibraryWidget> {
  List<dynamic> _videos = [];
  String? _selectedTag;
  String? _selectedPerson;

  @override
  void initState() {
    super.initState();
    _fetchVideos();
  }

  Future<void> _fetchVideos() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8000/videos'));
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          _videos = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load videos');
      }
    } catch (e) {
      debugPrint('Error fetching videos: $e');
    }
  }

  Future<String?> _getThumbnail(String videoPath) async {
    try {
      final randomFrame = Random().nextInt(1000);
      return await VideoThumbnail.thumbnailFile(
        video: videoPath,
        thumbnailPath: (await Directory.systemTemp.createTemp()).path,
        imageFormat: ImageFormat.JPEG,
        maxHeight: 400,
        quality: 85,
        timeMs: randomFrame,
      );
    } catch (e) {
      debugPrint('Error generating thumbnail: $e');
      return null;
    }
  }

  String _formatDate(String? timestamp) {
    if (timestamp == null) return 'Unknown';
    try {
      final date = DateTime.parse(timestamp);
      return DateFormat('dd MMM yyyy, hh:mm a').format(date);
    } catch (e) {
      debugPrint('Error formatting date: $e');
      return 'Unknown';
    }
  }

  void _clearFilters() {
    setState(() {
      _selectedTag = null;
      _selectedPerson = null;
    });
  }

    Widget _videoCard(dynamic video, Color themeColor, String? thumbnail) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VideoDisplayWidget(id: video['id'])),
        );
      },
      child: Card(
        elevation: 6,
        color: themeColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: thumbnail != null && File(thumbnail).existsSync()
                  ? Image.file(File(thumbnail), fit: BoxFit.cover)
                  : const Center(child: Icon(Icons.video_file, size: 50, color: Colors.grey)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Uploaded: ${_formatDate(video['timestamp'])}', style: GoogleFonts.outfit(color: Colors.white)),
                  if (video['tags'] != null) Text('Tags: ${video['tags'].join(', ')}', style: GoogleFonts.outfit(color: Colors.white70)),
                  if (video['people'] != null) Text('People: ${video['people'].join(', ')}', style: GoogleFonts.outfit(color: Colors.white70)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFF162d3a);

    final tags = _videos.expand((v) => v['tags'] ?? []).toSet().toList();
    final people = _videos.expand((v) => v['people'] ?? []).toSet().toList();

    final filteredVideos = _videos.where((video) {
      final matchesTag = _selectedTag == null || (video['tags']?.contains(_selectedTag) ?? false);
      final matchesPerson = _selectedPerson == null || (video['people']?.contains(_selectedPerson) ?? false);
      return matchesTag && matchesPerson;
    }).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Video Library',
          style: GoogleFonts.outfit(
            textStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(color: themeColor, fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  DropdownButton<String>(
                    value: _selectedTag,
                    hint: Text('Filter by Tag', style: GoogleFonts.outfit(color: themeColor)),
                    items: tags.map((tag) => DropdownMenuItem<String>(
                      value: tag,
                      child: Text(tag, style: GoogleFonts.outfit(color: themeColor)),
                    )).toList(),
                    onChanged: (value) {
                        setState(() => _selectedTag = value);
                
                    },
                  ),
                  DropdownButton<String>(
                    value: _selectedPerson,
                    hint: Text('Filter by Person', style: GoogleFonts.outfit(color: themeColor)),
                    items: people.map((person) => DropdownMenuItem<String>(
                      value: person,
                      child: Text(person, style: GoogleFonts.outfit(color: themeColor)),
                    )).toList(),
                    onChanged: (value) {
                      setState(() => _selectedPerson = value);
                    },
                  ),
                  ElevatedButton(
                    onPressed: _clearFilters,
                    style: ElevatedButton.styleFrom(backgroundColor: themeColor),
                    child: Text('Clear Filters', style: GoogleFonts.outfit(color: Colors.white)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: filteredVideos.length,
                  itemBuilder: (context, index) {
                    final video = filteredVideos[index];
                    return FutureBuilder<String?>(
                      future: _getThumbnail(video['video_path']),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError || snapshot.data == null) {
                          return _videoCard(video, themeColor, null);
                        }
                        return _videoCard(video, themeColor, snapshot.data);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}





























