import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movies_app/screens/add_comment_to_tvshow.dart';
import 'package:movies_app/screens/tv_show_videos.dart';
import 'package:movies_app/services/tv_show_service.dart';
import '../models/comment_model.dart';
import '../models/tv_show_model.dart';
import '../services/add_comment.dart';
import '../services/add_favorites.dart';

class TvShowDetails extends StatefulWidget {
  final TvShow tvShow;

  const TvShowDetails({Key? key, required this.tvShow}) : super(key: key);

  @override
  _TvShowDetailsState createState() => _TvShowDetailsState();
}

class _TvShowDetailsState extends State<TvShowDetails> {
  final FirebaseService _firebaseService = FirebaseService();
  final CommentService _commentService = CommentService();
  final TvShowService _tvShowService = TvShowService();
  bool _isFavorite = false;
  bool _isInitialized = false;
  bool _hasVideos = false; // Add this flag to track video availability

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
    _checkIfVideosAvailable();
  }

  Future<void> _checkIfFavorite() async {
    bool isFavorite = await _firebaseService.isTvShowFavorite(widget.tvShow);
    setState(() {
      _isFavorite = isFavorite;
      _isInitialized = true;
    });
  }

  Future<void> _checkIfVideosAvailable() async {
    List<Map<String, String>> videos =
        await _tvShowService.fetchTvShowVideos(widget.tvShow.id);
    setState(() {
      _hasVideos = videos.isNotEmpty;
    });
  }

  void _showTvShowVideos() async {
    List<Map<String, String>> videos =
        await _tvShowService.fetchTvShowVideos(widget.tvShow.id);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TvShowVideosScreen(videos: videos),
      ),
    );
  }

  void _toggleFavorite() async {
    await _firebaseService.toggleFavoriteTvShow(widget.tvShow);
    setState(() {
      _isFavorite = !_isFavorite;
    });

    final snackBar = SnackBar(
      content: Text(_isFavorite
          ? 'Tv Show has been added to Favorites'
          : 'Tv Show has been removed from Favorites'),
      duration: Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tvShow.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  widget.tvShow.poster.isNotEmpty
                      ? Image.network(
                          'https://image.tmdb.org/t/p/w500${widget.tvShow.poster}',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 300,
                        )
                      : Container(
                          child: Image.asset('assets/no_image.jpg',
                              fit: BoxFit.cover),
                          width: double.infinity,
                          height: 300,
                          color: Colors.grey,
                        ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: _isInitialized
                        ? Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                _isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: _isFavorite ? Colors.red : Colors.white,
                                size: 30,
                              ),
                              onPressed: _toggleFavorite,
                            ),
                          )
                        : Container(), // Empty container to avoid layout issues
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                widget.tvShow.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Rating: ${widget.tvShow.rating.toStringAsFixed(1)}',
                    style: TextStyle(fontSize: 18),
                  ),
                  _hasVideos
                      ? ElevatedButton(
                          onPressed: _showTvShowVideos,
                          child: Text('Watch Videos'),
                        )
                      : Container(), // Show button only if there are videos
                ],
              ),
              const SizedBox(height: 16),
              Text(
                widget.tvShow.overview ?? 'No description available',
                style: TextStyle(fontSize: 16),
              ),
              Container(
                height: 200,
                child: StreamBuilder<List<Comment>>(
                  stream: _commentService
                      .getComments((widget.tvShow.id).toString()),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text('An error occurred: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No comments yet'));
                    } else {
                      List<Comment> comments = snapshot.data!;
                      return ListView.builder(
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          Comment comment = comments[index];
                          return ListTile(
                            title: Text(comment.userName),
                            subtitle: Text(comment.content),
                            trailing: Text(DateFormat('MMM d, yyyy')
                                .format(comment.timestamp)),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddCommentToTvShow(tvShow: widget.tvShow),
                    ),
                  );
                },
                child: Text('Add Comment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
