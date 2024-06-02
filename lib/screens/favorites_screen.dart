import 'package:flutter/material.dart';
import 'package:movies_app/screens/favorite_movies_screen.dart';
import 'package:movies_app/screens/favorite_tvShows.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorites'),),
      body: Column(
        children: [
          Row(
            children: [
              Text('Favorite Movies'),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FavoriteMoviesPage(),
                    ),
                  );
                },
                icon: Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
          Row(
            children: [
              Text('Favorite Tv Shows'),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FavoriteTvShowsPage(),
                    ),
                  );
                },
                icon: Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),

        ],
      ),
    );
  }
}
