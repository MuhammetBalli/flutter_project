import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movies_app/providers/movie_provider.dart';
import 'package:movies_app/models/movie_model.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart'; // Import your MovieProvider
import '../widgets/movie_list.dart'; // Import your MovieListWidget

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({Key? key}) : super(key: key);

  @override
  _MoviesScreenState createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);
    movieProvider.fetchNowPlayingMovies();

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !movieProvider.isLoading) {
      movieProvider.fetchNowPlayingMovies();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing Movies'),
      ),
      body: Consumer<MovieProvider>(
        builder: (context, movieProvider, child) {
          if (movieProvider.isLoading &&
              movieProvider.nowPlayingMovies.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else if (movieProvider.nowPlayingMovies.isEmpty) {
            return const Center(child: Text('No movies available'));
          } else {
            return ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: movieProvider.nowPlayingMovies.length +
                  (movieProvider.isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == movieProvider.nowPlayingMovies.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                final movie = movieProvider.nowPlayingMovies[index];
                return Container(
                  width: 160,
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      movie.poster.isNotEmpty
                          ? Image.network(
                              'https://image.tmdb.org/t/p/w500${movie.poster}',
                              fit: BoxFit.cover,
                              width: 150,
                              height: 225,
                            )
                          : Container(
                              width: 150,
                              height: 225,
                              color: Colors.grey,
                            ),
                      const SizedBox(height: 8),
                      Text(
                        movie.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Release Date: ${movie.releaseDate}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
