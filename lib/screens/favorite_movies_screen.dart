import 'package:flutter/material.dart';
import 'package:movies_app/models/movie_model.dart';
import '../services/add_favorites.dart';
import 'movie_details.dart';

class FavoriteMoviesPage extends StatefulWidget {
  const FavoriteMoviesPage({Key? key}) : super(key: key);

  @override
  _FavoriteMoviesPageState createState() => _FavoriteMoviesPageState();
}

class _FavoriteMoviesPageState extends State<FavoriteMoviesPage> {
  final FirebaseService _firebaseService = FirebaseService();
  late Future<List<Movie>> _favoriteMoviesFuture;

  @override
  void initState() {
    super.initState();
    _loadFavoriteMovies();
  }

  void _loadFavoriteMovies() {
    _favoriteMoviesFuture = _firebaseService.getFavoriteMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favori Filmler'),
      ),
      body: FutureBuilder<List<Movie>>(
        future: _favoriteMoviesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Henüz favori filminiz yok'));
          } else {
            List<Movie> favoriteMovies = snapshot.data!;
            return ListView.builder(
              itemCount: favoriteMovies.length,
              itemBuilder: (context, index) {
                Movie movie = favoriteMovies[index];
                return ListTile(
                  leading: movie.poster.isNotEmpty
                      ? Image.network(
                          'https://image.tmdb.org/t/p/w500${movie.poster}',
                          fit: BoxFit.cover,
                          width: 50,
                        )
                      : Container(
                          width: 50,
                          color: Colors.grey,
                        ),
                  title: Text(movie.title),
                  subtitle: Text('Rating: ${movie.rating.toStringAsFixed(1)}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetails(movie: movie),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
