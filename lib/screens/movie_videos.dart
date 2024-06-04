import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieVideosScreen extends StatefulWidget {
  final List<Map<String, String>> videos;

  MovieVideosScreen({required this.videos});

  @override
  _MovieVideosScreenState createState() => _MovieVideosScreenState();
}

class _MovieVideosScreenState extends State<MovieVideosScreen> {
  List<YoutubePlayerController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _controllers = widget.videos.map((video) {
      return YoutubePlayerController(
        initialVideoId: video['key']!,
        flags: YoutubePlayerFlags(
          autoPlay: false,
        ),
      );
    }).toList();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Trailers'),
      ),
      body: widget.videos.isEmpty
          ? Center(child: Text('No videos for this movie'))
          : ListView.builder(
        itemCount: widget.videos.length,
        itemBuilder: (context, index) {
          final video = widget.videos[index];
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                YoutubePlayer(
                  controller: _controllers[index],
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Colors.amber,
                ),
                SizedBox(height: 8),
                Text(
                  video['name']!,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}




