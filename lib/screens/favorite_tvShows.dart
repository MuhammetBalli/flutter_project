import 'package:flutter/material.dart';
import 'package:movies_app/models/movie_model.dart';
import 'package:movies_app/screens/tv_show_details.dart';
import '../models/tv_show_model.dart';
import '../services/add_favorites.dart';
import 'movie_details.dart';

class FavoriteTvShowsPage extends StatefulWidget {
  const FavoriteTvShowsPage({Key? key}) : super(key: key);

  @override
  _FavoriteTvShowsPageState createState() => _FavoriteTvShowsPageState();
}

class _FavoriteTvShowsPageState extends State<FavoriteTvShowsPage> {
  final FirebaseService _firebaseService = FirebaseService();
  late Future<List<TvShow>> _favoriteTvShowsFuture;

  @override
  void initState() {
    super.initState();
    _favoriteTvShowsFuture = _firebaseService.getFavoriteTvShows();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Tv Shows'),
      ),
      body: FutureBuilder<List<TvShow>>(
        future: _favoriteTvShowsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Henüz favori filminiz yok'));
          } else {
            List<TvShow> favoriteTvShows = snapshot.data!;
            return ListView.builder(
              itemCount: favoriteTvShows.length,
              itemBuilder: (context, index) {
                TvShow tvShow = favoriteTvShows[index];
                return ListTile(
                  leading: tvShow.poster.isNotEmpty
                      ? Image.network(
                    'https://image.tmdb.org/t/p/w500${tvShow.poster}',
                    fit: BoxFit.cover,
                    width: 50,
                  )
                      : Container(
                    width: 50,
                    color: Colors.grey,
                  ),
                  title: Text(tvShow.name),
                  subtitle: Text('Rating: ${tvShow.rating.toStringAsFixed(1)}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TvShowDetails(tvShow: tvShow),
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