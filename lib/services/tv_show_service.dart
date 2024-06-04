import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tv_show_model.dart';

class TvShowService {
  final String apiKey = '8292dd1bd676f4b1a4771e1299d3df5a';

  Future<List<TvShow>> fetchAiringTodayTvShows(int page) async {
    final String baseUrl = 'https://api.themoviedb.org/3/tv/airing_today';
    final String url = '$baseUrl?api_key=$apiKey&page=$page';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<TvShow> tvShows = [];
        for (var item in jsonData['results']) {
          tvShows.add(TvShow.fromJson(item));
        }
        return tvShows;
      } else {
        throw Exception('Failed to load airing today TV shows');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<TvShow>> fetchOnTheAirTvShows(int page) async {
    final String baseUrl = 'https://api.themoviedb.org/3/tv/on_the_air';
    final String url = '$baseUrl?api_key=$apiKey&page=$page';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<TvShow> tvShows = [];
        for (var item in jsonData['results']) {
          tvShows.add(TvShow.fromJson(item));
        }
        return tvShows;
      } else {
        throw Exception('Failed to load on the air TV shows');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<TvShow>> fetchPopularTvShows(int page) async {
    final String baseUrl = 'https://api.themoviedb.org/3/tv/popular';
    final String url = '$baseUrl?api_key=$apiKey&page=$page';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<TvShow> tvShows = [];
        for (var item in jsonData['results']) {
          tvShows.add(TvShow.fromJson(item));
        }
        return tvShows;
      } else {
        throw Exception('Failed to load on the air TV shows');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<TvShow>> fetchTopRatedTvShows(int page) async {
    final String baseUrl = 'https://api.themoviedb.org/3/tv/top_rated';
    final String url = '$baseUrl?api_key=$apiKey&page=$page';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<TvShow> tvShows = [];
        for (var item in jsonData['results']) {
          tvShows.add(TvShow.fromJson(item));
        }
        return tvShows;
      } else {
        throw Exception('Failed to load on the air TV shows');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<Map<String, String>>> fetchTvShowVideos(int tvShowId) async {
    final response = await http.get(
      Uri.parse('https://api.themoviedb.org/3/tv/$tvShowId/videos?api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<Map<String, String>> videos = [];
      for (var result in data['results']) {
        if (result['site'] == 'YouTube') {
          videos.add({
            'name': result['name'],
            'key': result['key'],
          });
        }
      }
      return videos;
    } else {
      throw Exception('Failed to load videos');
    }
  }
}
