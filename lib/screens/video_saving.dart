import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class VideoSavingWidget extends StatefulWidget {
  const VideoSavingWidget({super.key});

  @override
  State<VideoSavingWidget> createState() => _VideoSavingWidgetState();
}

class _VideoSavingWidgetState extends State<VideoSavingWidget> {
  late TextEditingController textController1;
  late TextEditingController textController2;
  double ratingBarValue = 0.0;
  String? dropDownValue = 'Local Storage';

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    textController1 = TextEditingController();
    textController2 = TextEditingController();
  }

  @override
  void dispose() {
    textController1.dispose();
    textController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFFF5F1ED), // Background color
        appBar: AppBar(
          backgroundColor: Color(0xFFF5F1ED),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Space evenly
              crossAxisAlignment: CrossAxisAlignment.center, // Align items centrally
              children: [
                // Video Player
                Container(
                  height: 200,
                  child: VideoPlayerWidget(), // Custom VideoPlayer widget here
                ),
                Padding(
                  padding: EdgeInsets.all(8), 
                  child: Text(
                    'Your mood today?',
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), 
                  child: Container(
                    width: 400, 
                    height: 46,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                    ),
                    child: RatingBar.builder(
                      onRatingUpdate: (newValue) {
                        setState(() {
                          ratingBarValue = newValue;
                        });
                      },
                      itemBuilder: (context, index) => Icon(
                        Icons.star_rounded,
                        color: Colors.orange,
                      ),
                      direction: Axis.horizontal,
                      initialRating: ratingBarValue,
                      unratedColor: Colors.grey,
                      itemCount: 5,
                      itemPadding: EdgeInsets.all(4), 
                      itemSize: 30,
                      glowColor: Colors.orange,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8), 
                  child: Text(
                    'Add tags',
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  width: 400, 
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                  ),
                  child: TextFormField(
                    controller: textController1,
                    decoration: InputDecoration(
                      labelText: 'Tag',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8), 
                  child: Text(
                    'Add people',
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  width: 400, 
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                  ),
                  child: TextFormField(
                    controller: textController2,
                    decoration: InputDecoration(
                      labelText: 'People',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8), 
                  child: Text(
                    'Storage Location',
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                DropdownButton<String>(
                  value: dropDownValue,
                  items: ['Local Storage', 'Google Drive']
                      .map((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      dropDownValue = newValue;
                    });
                  },
                  isExpanded: true,
                ),
                Padding(
                  padding: EdgeInsets.all(16), 
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          print('Save pressed ...');
                        },
                        child: Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 18, 
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          backgroundColor: Color(0xFF70798C), // Button color
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          print('Discard pressed ...');
                        },
                        child: Text(
                          'Discard',
                          style: TextStyle(
                            fontSize: 18, 
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          backgroundColor: Color(0xFF70798C), // Button color
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VideoPlayerWidget extends StatelessWidget {
  //video code here, I think this part can go in the widgets folder
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Icon(
          Icons.play_arrow,
          color: Colors.white,
          size: 50,
        ),
      ),
    );
  }
}
