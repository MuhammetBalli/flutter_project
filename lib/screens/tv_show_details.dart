import 'package:flutter/material.dart';
import '../models/tv_show_model.dart';
import '../services/add_favorites.dart';

class TvShowDetails extends StatefulWidget {
  final TvShow tvShow;

  const TvShowDetails({Key? key, required this.tvShow}) : super(key: key);

  @override
  _TvShowDetailsState createState() => _TvShowDetailsState();
}

class _TvShowDetailsState extends State<TvShowDetails> {
  final FirebaseService _firebaseService = FirebaseService();
  bool _isFavorite = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    bool isFavorite = await _firebaseService.isTvShowFavorite(widget.tvShow);
    setState(() {
      _isFavorite = isFavorite;
      _isInitialized = true;
    });
  }

  void _toggleFavorite() async {
    await _firebaseService.toggleFavoriteTvShow(widget.tvShow);
    setState(() {
      _isFavorite = !_isFavorite;
    });

    final snackBar = SnackBar(
      content: Text(_isFavorite
          ? 'Tv Show has added to Favorites'
          : 'Tv Show has removed from Favorites'),
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
                    child: Image.asset('assets/no_image.jpg', fit: BoxFit.cover),
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
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
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
                widget.tvShow.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Rating: ${widget.tvShow.rating.toStringAsFixed(1)}',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              Text(
                widget.tvShow.overview ?? 'No description available',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
