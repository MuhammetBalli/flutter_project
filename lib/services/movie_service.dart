import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie_model.dart';

class MovieService {
  final String apiKey = '8292dd1bd676f4b1a4771e1299d3df5a'; // Replace 'YOUR_API_KEY' with your actual API key

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
}
