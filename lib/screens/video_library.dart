import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VideoLibraryWidget extends StatefulWidget {
  const VideoLibraryWidget({Key? key}) : super(key: key);

  @override
  State<VideoLibraryWidget> createState() => _VideoLibraryWidgetState();
}

class _VideoLibraryWidgetState extends State<VideoLibraryWidget> {
  String? _selectedViewMode;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            'Video Library',
            style: GoogleFonts.outfit(
              textStyle: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.tune),
              onPressed: () {
                // Add filter functionality
              },
            ),
          ],
          centerTitle: false,
          elevation: 0,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            'View By',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              ChoiceChip(
                                label: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.calendar_today, size: 18),
                                    SizedBox(width: 4),
                                    Text('Timeline'),
                                  ],
                                ),
                                selected: _selectedViewMode == 'Timeline',
                                onSelected: (bool selected) {
                                  setState(() {
                                    _selectedViewMode = selected ? 'Timeline' : null;
                                  });
                                },
                              ),
                              ChoiceChip(
                                label: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.mood, size: 18),
                                    SizedBox(width: 4),
                                    Text('Moods'),
                                  ],
                                ),
                                selected: _selectedViewMode == 'Moods',
                                onSelected: (bool selected) {
                                  setState(() {
                                    _selectedViewMode = selected ? 'Moods' : null;
                                  });
                                },
                              ),
                              ChoiceChip(
                                label: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.local_offer, size: 18),
                                    SizedBox(width: 4),
                                    Text('Tags'),
                                  ],
                                ),
                                selected: _selectedViewMode == 'Tags',
                                onSelected: (bool selected) {
                                  setState(() {
                                    _selectedViewMode = selected ? 'Tags' : null;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  _buildMonthSection(
                    context, 
                    month: 'December 2024', 
                    entryCount: 12, 
                    videos: [
                      _VideoEntry(
                        imageUrl: 'https://images.unsplash.com/photo-1541580621-cb65cc53084b?w=500&h=500',
                        date: '27 Dec',
                        moods: ['Happy', 'Grateful'],
                      ),
                      _VideoEntry(
                        imageUrl: 'https://images.unsplash.com/photo-1518081896461-7cba17ff62d9?w=500&h=500',
                        date: '24 Dec',
                        moods: ['Reflective'],
                      ),
                    ],
                  ),
                  _buildMonthSection(
                    context, 
                    month: 'November 2024', 
                    entryCount: 8, 
                    videos: [
                      _VideoEntry(
                        imageUrl: 'https://images.unsplash.com/photo-1594750852517-f37738fa2384?w=500&h=500',
                        date: '15 Nov',
                        moods: ['Excited', 'Milestone'],
                      ),
                      _VideoEntry(
                        imageUrl: 'https://images.unsplash.com/photo-1523193467949-4c840d8d04f1?w=500&h=500',
                        date: '8 Nov',
                        moods: ['Calm', 'Nature'],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMonthSection(
    BuildContext context, {
    required String month, 
    required int entryCount, 
    required List<_VideoEntry> videos,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  month,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  '$entryCount entries',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 200,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: videos.length,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  return _buildVideoCard(context, videos[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoCard(BuildContext context, _VideoEntry video) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              video.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.black],
                stops: const [0.6, 1],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: video.moods.map((mood) => 
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                        child: Text(
                          mood,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      )
                    ).toList(),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    video.date,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoEntry {
  final String imageUrl;
  final String date;
  final List<String> moods;

  _VideoEntry({
    required this.imageUrl,
    required this.date,
    required this.moods,
  });
}