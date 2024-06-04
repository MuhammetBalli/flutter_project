import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TvShowVideosScreen extends StatelessWidget {
  final List<Map<String, String>> videos;

  TvShowVideosScreen({required this.videos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Videos'),
      ),
      body: videos.isEmpty
          ? Center(child: Text('No videos for this Tv Show'))
          : ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                YoutubePlayer(
                  controller: YoutubePlayerController(
                    initialVideoId: video['key']!,
                    flags: YoutubePlayerFlags(
                      autoPlay: false,
                    ),
                  ),
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