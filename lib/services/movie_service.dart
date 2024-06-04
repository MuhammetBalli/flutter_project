import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie_model.dart';

class MovieService {
  final String apiKey = '8292dd1bd676f4b1a4771e1299d3df5a';

  Future<List<Movie>> fetchNowPlayingMovies(int page) async {
    final String baseUrl = 'https://api.themoviedb.org/3/movie/now_playing';
    final String url = '$baseUrl?api_key=$apiKey&page=$page';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<Movie> movies = [];
        for (var item in jsonData['results']) {
          movies.add(Movie.fromJson(item));
        }
        return movies;
      } else {
        throw Exception('Failed to load now playing movies');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<Movie>> fetchPopularMovies(int page) async {
    final String baseUrl = 'https://api.themoviedb.org/3/movie/popular';
    final String url = '$baseUrl?api_key=$apiKey&page=$page';

    try {
      final response = await http.get(Uri.parse(url),);
      print('___________________');
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {

        final jsonData = json.decode(response.body);
        print(jsonData); // API yanıtını kontrol etmek için
        final List<Movie> movies = [];
        for (var item in jsonData['results']) {
          movies.add(Movie.fromJson(item));
        }
        return movies;
      } else {
        throw Exception('Failed to load popular movies');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<Movie>> fetchTopRatedMovies(int page) async {
    final String baseUrl = 'https://api.themoviedb.org/3/movie/top_rated';
    final String url = '$baseUrl?api_key=$apiKey&page=$page';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<Movie> movies = [];
        for (var item in jsonData['results']) {
          movies.add(Movie.fromJson(item));
        }
        return movies;
      } else {
        throw Exception('Failed to load top rated movies');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<Movie>> fetchUpcomingMovies(int page) async {
    final String baseUrl = 'https://api.themoviedb.org/3/movie/upcoming';
    final String url = '$baseUrl?api_key=$apiKey&page=$page';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<Movie> movies = [];
        for (var item in jsonData['results']) {
          movies.add(Movie.fromJson(item));
        }
        return movies;
      } else {
        throw Exception('Failed to upcoming movies');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<Map<String, String>>> fetchMovieVideos(int movieId) async {
    final response = await http.get(
      Uri.parse('https://api.themoviedb.org/3/movie/$movieId/videos?api_key=$apiKey'),
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

