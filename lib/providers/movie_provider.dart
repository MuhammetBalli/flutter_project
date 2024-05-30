import 'package:flutter/material.dart';
import 'package:movies_app/services/movie_service.dart';
import '../models/movie_model.dart';

class MovieProvider with ChangeNotifier {
  List<Movie> _nowPlayingMovies = [];
  int _currentPage = 1;
  bool _isLoading = false;

  List<Movie> get nowPlayingMovies => _nowPlayingMovies;
  bool get isLoading => _isLoading;

  final MovieService _movieService = MovieService();
  final ScrollController scrollController = ScrollController();

  Future<void> fetchNowPlayingMovies() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      List<Movie> newMovies = await _movieService.fetchNowPlayingMovies(_currentPage);
      _nowPlayingMovies.addAll(newMovies);
      _currentPage++;
    } catch (e) {
      // Handle error
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}


