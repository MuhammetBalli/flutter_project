import 'package:flutter/material.dart';
import 'package:movies_app/services/movie_service.dart';
import '../models/movie_model.dart';

class MovieProvider with ChangeNotifier {
  List<Movie> _nowPlayingMovies = [];
  List<Movie> _popularMovies = [];
  List<Movie> _topRatedMovies=[];
  List<Movie> _upcomingMovies=[];

  int _currentPageNowPlaying = 1;
  int _currentPagePopular = 1;
  int _currentPageTopRated=1;
  int _currentPageUpcoming=1;

  bool _isNowPlayingLoading = false;
  bool _isPopularLoading = false;
  bool _isTopRatedLoading=false;
  bool _isUpcomingLoading=false;

  List<Movie> get nowPlayingMovies => _nowPlayingMovies;
  List<Movie> get popularMovies => _popularMovies;
  List<Movie> get topRatedMovies => _topRatedMovies;
  List<Movie> get upcomingMovies => _upcomingMovies;

  bool get isLoading => _isNowPlayingLoading;
  bool get isPopularLoading => _isPopularLoading;
  bool get isTopRatedLoading =>_isTopRatedLoading;
  bool get isUpcomingLoaded => _isUpcomingLoading;


  final MovieService _movieService = MovieService();
  final ScrollController scrollController = ScrollController();

  Future<void> fetchNowPlayingMovies() async {
    if (_isNowPlayingLoading) return;

    _isNowPlayingLoading = true;
    notifyListeners();

    try {
      List<Movie> newMovies = await _movieService.fetchNowPlayingMovies(_currentPageNowPlaying);
      newMovies.removeWhere((newMovie) => _nowPlayingMovies.any((existingMovie) => existingMovie.id == newMovie.id));
      _nowPlayingMovies.addAll(newMovies);
      _currentPageNowPlaying++;
    } catch (e) {
      print(e);
    } finally {
      _isNowPlayingLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPopularMovies() async {
    if (_isPopularLoading) return;

    _isPopularLoading = true;
    notifyListeners();

    try {
      List<Movie> newMovies = await _movieService.fetchPopularMovies(_currentPagePopular);
      print('Yeni Filmler: $newMovies'); // Veri kontrolü için
      newMovies.removeWhere((newMovie) => _popularMovies.any((existingMovie) => existingMovie.id == newMovie.id));
      _popularMovies.addAll(newMovies);
      print('Güncellenmiş Popüler Filmler: $_popularMovies'); // Eklenen filmleri kontrol etmek için
      _currentPagePopular++;
    } catch (e) {
      print(e);
    } finally {
      _isPopularLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTopRatedMovies() async {
    if (_isTopRatedLoading) return;

    _isTopRatedLoading = true;
    notifyListeners();

    try {
      List<Movie> newMovies = await _movieService.fetchTopRatedMovies(_currentPageTopRated);
      newMovies.removeWhere((newMovie) => _topRatedMovies.any((existingMovie) => existingMovie.id == newMovie.id));
      _topRatedMovies.addAll(newMovies);
      _currentPageTopRated++;
    } catch (e) {
      print(e);
    } finally {
      _isTopRatedLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUpComingMovies() async {
    if (_isUpcomingLoading) return;

    _isUpcomingLoading = true;
    notifyListeners();

    try {
      List<Movie> newMovies = await _movieService.fetchUpcomingMovies(_currentPageUpcoming);
      newMovies.removeWhere((newMovie) => _upcomingMovies.any((existingMovie) => existingMovie.id == newMovie.id));
      _upcomingMovies.addAll(newMovies);
      _currentPageUpcoming++;
    } catch (e) {
      print(e);
    } finally {
      _isUpcomingLoading = false;
      notifyListeners();
    }
  }


}




