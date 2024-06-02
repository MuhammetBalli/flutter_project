import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movies_app/providers/movie_provider.dart';
import 'package:movies_app/screens/movie_details.dart';

class TopRatedMovies extends StatefulWidget {
  const TopRatedMovies({Key? key}) : super(key: key);

  @override
  _TopRatedMoviesState createState() => _TopRatedMoviesState();
}

class _TopRatedMoviesState extends State<TopRatedMovies> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);
    movieProvider.fetchTopRatedMovies();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 &&
        !movieProvider.isTopRatedLoading) {
      movieProvider.fetchTopRatedMovies();
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
          if (movieProvider.isTopRatedLoading &&
              movieProvider.topRatedMovies.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else if (movieProvider.topRatedMovies.isEmpty) {
            return const Center(child: Text('No movies available'));
          } else {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Top Rated'),
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
                    itemCount: movieProvider.topRatedMovies.length +
                        (movieProvider.isTopRatedLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == movieProvider.topRatedMovies.length) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final movie = movieProvider.topRatedMovies[index];
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
                              Text(movie.rating.toStringAsFixed(1)),
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