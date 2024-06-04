import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movies_app/providers/movie_provider.dart';
import 'package:movies_app/screens/movie_details.dart';

class NowPlayingMovies extends StatefulWidget {
  const NowPlayingMovies({Key? key}) : super(key: key);

  @override
  _NowPlayingMoviesState createState() => _NowPlayingMoviesState();
}

class _NowPlayingMoviesState extends State<NowPlayingMovies> {
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
    return Scaffold(
      body: Consumer<MovieProvider>(
        builder: (context, movieProvider, child) {
          if (movieProvider.isLoading &&
              movieProvider.nowPlayingMovies.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else if (movieProvider.nowPlayingMovies.isEmpty) {
            return const Center(child: Text('No movies available'));
          } else {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Now Playing'),
                      Text('See all'),
                    ],
                  ),
                ),
                Container(
                  height: 330,
                  //color: Colors.red,
                  child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: movieProvider.nowPlayingMovies.length +
                        (movieProvider.isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == movieProvider.nowPlayingMovies.length) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final movie = movieProvider.nowPlayingMovies[index];
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
                              Stack(
                                children: [
                                  Container(
                                    width: 150,
                                    height: 225,
                                    color: Colors.grey[300],
                                    child:  Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.blue[200],
                                      ),
                                    ),
                                  ),
                                  Image.network(
                                    'https://image.tmdb.org/t/p/w500${movie.poster}',
                                    fit: BoxFit.cover,
                                    width: 150,
                                    height: 225,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        width: 150,
                                        height: 225,
                                        color: Colors.grey[300],
                                        child:Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.blue[200],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
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
                              movie.rating == 0
                                  ? Text("")
                                  : Text(movie.rating.toStringAsFixed(1)),
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
