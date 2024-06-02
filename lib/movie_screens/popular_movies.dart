import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movies_app/providers/movie_provider.dart';

import '../screens/movie_details.dart';


class popularMovies extends StatefulWidget {
  const popularMovies({Key? key}) : super(key: key);

  @override
  _popularMoviesState createState() => _popularMoviesState();
}

class _popularMoviesState extends State<popularMovies> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    print('klşdksaşldkasşkaş');
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);
    movieProvider.fetchPopularMovies();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 &&
        !movieProvider.isPopularLoading) {
      movieProvider.fetchPopularMovies();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MovieProvider>(
        builder: (context, movieProvider, child) {
          if (movieProvider.isPopularLoading &&
              movieProvider.popularMovies.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else if (movieProvider.popularMovies.isEmpty) {
            return const Center(child: Text('No movies available'));
          } else {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Popular'),
                      Text('See all'),
                    ],
                  ),
                ),
                Container(
                  height: 330,
                  color: Colors.red,
                  child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: movieProvider.popularMovies.length +
                        (movieProvider.isPopularLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == movieProvider.popularMovies.length) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final movie = movieProvider.popularMovies[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieDetails(movie: movie),
                            ),
                          );
                        },
                        child: Container(
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
                                  movie.rating.toStringAsFixed(1)
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}


