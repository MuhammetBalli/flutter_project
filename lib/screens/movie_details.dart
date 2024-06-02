import 'package:flutter/material.dart';
import 'package:movies_app/models/movie_model.dart';
import '../services/add_favorites.dart';

class MovieDetails extends StatefulWidget {
  final Movie movie;

  const MovieDetails({Key? key, required this.movie}) : super(key: key);

  @override
  _MovieDetailsState createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  final FirebaseService _firebaseService = FirebaseService();
  bool _isFavorite = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    bool isFavorite = await _firebaseService.isMovieFavorite(widget.movie);
    setState(() {
      _isFavorite = isFavorite;
      _isInitialized = true;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
      ),
      body: Padding(
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
            Text(
              'Rating: ${widget.movie.rating.toStringAsFixed(1)}',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Text(
              widget.movie.overview ?? 'No description available',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}






















