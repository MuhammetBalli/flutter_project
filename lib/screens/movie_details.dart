import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/models/movie_model.dart';
import 'package:movies_app/services/movie_service.dart';
import '../models/comment_model.dart';
import '../services/add_comment.dart';
import '../services/add_favorites.dart';
import 'add_comment_to_movie.dart';
import 'movie_videos.dart';

class MovieDetails extends StatefulWidget {
  final Movie movie;

  const MovieDetails({Key? key, required this.movie}) : super(key: key);

  @override
  _MovieDetailsState createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  final FirebaseService _firebaseService = FirebaseService();
  final CommentService _commentService = CommentService();
  final MovieService _movieService = MovieService();
  bool _isFavorite = false;
  bool _isInitialized = false;
  bool _hasVideos = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
    _checkIfVideosAvailable();
  }

  Future<void> _checkIfFavorite() async {
    bool isFavorite = await _firebaseService.isMovieFavorite(widget.movie);
    setState(() {
      _isFavorite = isFavorite;
      _isInitialized = true;
    });
  }

  Future<void> _checkIfVideosAvailable() async {
    List<Map<String, String>> videos =
        await _movieService.fetchMovieVideos(widget.movie.id);
    setState(() {
      _hasVideos = videos.isNotEmpty;
    });
  }

  void _toggleFavorite() async {
    await _firebaseService.toggleFavoriteMovie(widget.movie);
    setState(() {
      _isFavorite = !_isFavorite;
    });

    final snackBar = SnackBar(
      content: Text(_isFavorite
          ? 'Film favorilere eklendi'
          : 'Film favorilerden çıkarıldı'),
      duration: Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showMovieVideos() async {
    List<Map<String, String>> videos =
        await _movieService.fetchMovieVideos(widget.movie.id);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieVideosScreen(videos: videos),
      ),
    ).then((_) {
      setState(() {}); // Rebuild MovieDetails screen when returning
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  widget.movie.poster.isNotEmpty
                      ? Image.network(
                          'https://image.tmdb.org/t/p/w500${widget.movie.poster}',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 300,
                        )
                      : Container(
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
                        : Container(), // Boş bir container, herhangi bir yükleme göstergesi olmadan
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                widget.movie.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Rating: ${widget.movie.rating.toStringAsFixed(1)}',
                    style: TextStyle(fontSize: 18),
                  ),
                  _hasVideos
                      ? ElevatedButton(
                          onPressed: _showMovieVideos,
                          child: Text('Watch Videos'),
                        )
                      : Container(),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                widget.movie.overview ?? 'No description available',
                style: TextStyle(fontSize: 16),
              ),
              Container(
                height: 200,
                child: StreamBuilder<List<Comment>>(
                  stream:
                      _commentService.getComments((widget.movie.id).toString()),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text('Bir hata oluştu: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('Henüz yorum yok'));
                    } else {
                      List<Comment> comments = snapshot.data!;
                      return ListView.builder(
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          Comment comment = comments[index];
                          return ListTile(
                            title: Text(comment.userName),
                            subtitle: Text(comment.content),
                            trailing:
                                Text(comment.timestamp.toLocal().toString()),
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
                          AddCommentToMovie(movie: widget.movie),
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
