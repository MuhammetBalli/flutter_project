import 'package:flutter/material.dart';
import '../models/movie_model.dart'; // Import your Movie model

class MovieListWidget extends StatelessWidget {
  final List<Movie> movies;
  final bool isLoading;
  final ScrollController scrollController;
  final VoidCallback onScroll;

  const MovieListWidget({
    Key? key,
    required this.movies,
    required this.isLoading,
    required this.scrollController,
    required this.onScroll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection:Axis.horizontal ,
      itemCount: movies.length + (isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == movies.length) {
          // Loading indicator
          return Center(child: CircularProgressIndicator());
        }

        final movie = movies[index];
        return ListTile(
          title: Text(movie.title),
          subtitle: Text('Release Date: ${movie.releaseDate}'),
          leading: Image.network(movie.poster),
          onTap: () {
            // Handle movie tap
          },
        );
      },
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
    );
  }
}

