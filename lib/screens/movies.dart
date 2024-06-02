import 'package:flutter/material.dart';
import 'package:movies_app/movie_screens/now_playing_movies.dart';
import 'package:movies_app/movie_screens/popular_movies.dart';
import 'package:movies_app/movie_screens/top_rated_movies.dart';
import 'package:movies_app/movie_screens/upcoming_movies.dart';

class Movies extends StatefulWidget {
  const Movies({super.key});

  @override
  State<Movies> createState() => _MoviesState();
}

class _MoviesState extends State<Movies> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Movies'),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 380,
              child: NowPlayingMovies(),
            ),
            Container(
              height: 380,
              child: popularMovies(),
            ),
            Container(
              height: 380,
              child: TopRatedMovies(),
            ),
            Container(
              height: 380,
              child: UpcomingMovies(),
            ),
          ],
        ),
      ),
    );
  }
}
