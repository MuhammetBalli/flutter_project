import 'package:flutter/cupertino.dart';
import 'package:movies_app/services/tv_show_service.dart';

import '../models/tv_show_model.dart';

class TvShowProvider with ChangeNotifier {

  List<TvShow> _tvShowsAiringToday = [];
  List<TvShow> _tvShowsOnTheAir =[];
  List<TvShow> _tvShowsPopular =[];
  List<TvShow> _tvShowsTopRated=[];


  int _currentAiringTodayTvShowPage = 1;
  int _currentOnTheAirTvShowsPage =1;
  int _currentPopularTvShowsPage =1;
  int _currentTopRatedTvShowsPage =1;


  bool _isAiringTodayTvShowLoading = false;
  bool _isOnTheAirTvShowLoading = false;
  bool _isPopularTvShowLoading = false;
  bool _isTopRatedTvShowLoading = false;


  List<TvShow> get tvShowsAiringToday => _tvShowsAiringToday;
  List<TvShow> get tvShowsOnTheAir => _tvShowsOnTheAir;
  List<TvShow> get tvShowsPopular => _tvShowsPopular;
  List<TvShow> get tvShowsTopRated => _tvShowsTopRated;

  bool get isAiringTodayTvShowLoading => _isAiringTodayTvShowLoading;
  bool get isOnTheAirTvShowLoading => _isOnTheAirTvShowLoading;
  bool get isPopularTvShowLoading => _isPopularTvShowLoading;
  bool get isTopRatedTvShowLoading => _isTopRatedTvShowLoading;

  final TvShowService _tvShowService = TvShowService();
  final ScrollController scrollController = ScrollController();

  Future<void> fetchAiringTodayTvShows() async {
    if (_isAiringTodayTvShowLoading) return;

    _isAiringTodayTvShowLoading = true;
    notifyListeners();

    try {
      List<TvShow> tvShows = await _tvShowService.fetchAiringTodayTvShows(_currentAiringTodayTvShowPage);
      tvShows.removeWhere((tvShow) => _tvShowsAiringToday.any((existingTvShow) => existingTvShow.id == tvShow.id));
      _tvShowsAiringToday.addAll(tvShows);
      _currentAiringTodayTvShowPage++;
    } catch (e) {
      print(e);
    } finally {
      _isAiringTodayTvShowLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchOnTheAirTvShows() async {
    if (_isOnTheAirTvShowLoading) return;

    _isOnTheAirTvShowLoading = true;
    notifyListeners();

    try {
      List<TvShow> tvShows = await _tvShowService.fetchOnTheAirTvShows(_currentOnTheAirTvShowsPage);
      tvShows.removeWhere((tvShow) => _tvShowsOnTheAir.any((existingTvShow) => existingTvShow.id == tvShow.id));
      _tvShowsOnTheAir.addAll(tvShows);
      _currentOnTheAirTvShowsPage++;
    } catch (e) {
      print(e);
    } finally {
      _isOnTheAirTvShowLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPopularTvShows() async {
    if (_isPopularTvShowLoading) return;

    _isPopularTvShowLoading = true;
    notifyListeners();

    try {
      List<TvShow> tvShows = await _tvShowService.fetchPopularTvShows(_currentPopularTvShowsPage);
      tvShows.removeWhere((tvShow) => _tvShowsPopular.any((existingTvShow) => existingTvShow.id == tvShow.id));
      _tvShowsPopular.addAll(tvShows);
      _currentPopularTvShowsPage++;
    } catch (e) {
      print(e);
    } finally {
      _isPopularTvShowLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTopRatedTvShows() async {
    if (_isTopRatedTvShowLoading) return;

    _isTopRatedTvShowLoading = true;
    notifyListeners();

    try {
      List<TvShow> tvShows = await _tvShowService.fetchTopRatedTvShows(_currentTopRatedTvShowsPage);
      tvShows.removeWhere((tvShow) => _tvShowsTopRated.any((existingTvShow) => existingTvShow.id == tvShow.id));
      _tvShowsTopRated.addAll(tvShows);
      _currentTopRatedTvShowsPage++;
    } catch (e) {
      print(e);
    } finally {
      _isTopRatedTvShowLoading = false;
      notifyListeners();
    }
  }

}
