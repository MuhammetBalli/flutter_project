import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movies_app/models/tv_show_model.dart';
import '../models/movie_model.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> toggleFavoriteMovie(Movie movie) async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentReference userRef = _firestore.collection('users').doc(user.uid);
      DocumentSnapshot userDoc = await userRef.get();

      Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
      if (data == null || !data.containsKey('favorites')) {
        await userRef.set({'favorites': []}, SetOptions(merge: true));
        userDoc = await userRef.get();
        data = userDoc.data() as Map<String, dynamic>?;
      }

      List<dynamic> favorites = data!['favorites'] ?? [];
      if (favorites.any((fav) => fav['id'] == movie.id)) {
        favorites.removeWhere((fav) => fav['id'] == movie.id);
      } else {
        favorites.add({
          'id': movie.id,
          'title': movie.title,
          'poster_path': movie.poster,
          'vote_average': movie.rating,
          'overview':movie.overview,
          'genre_ids':movie.genreIds,
          'release_date':movie.releaseDate
        });
      }
      await userRef.update({'favorites': favorites});
    }
  }

  Future<void> toggleFavoriteTvShow(TvShow tvShow) async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentReference userRef = _firestore.collection('users').doc(user.uid);
      DocumentSnapshot userDoc = await userRef.get();

      Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
      if (data == null || !data.containsKey('favorite_tvShows')) {
        await userRef.set({'favorite_tvShows': []}, SetOptions(merge: true));
        userDoc = await userRef.get();
        data = userDoc.data() as Map<String, dynamic>?;
      }

      List<dynamic> favorites = data!['favorite_tvShows'] ?? [];
      if (favorites.any((fav) => fav['id'] == tvShow.id)) {
        favorites.removeWhere((fav) => fav['id'] == tvShow.id);
      } else {
        favorites.add({
          'id': tvShow.id,
          'name': tvShow.name,
          'poster_path': tvShow.poster,
          'vote_average': tvShow.rating,
          'overview':tvShow.overview,
          'genre_ids':tvShow.genreIds,
          'first_air_date':tvShow.firstAirDate
        });
      }
      await userRef.update({'favorite_tvShows': favorites});
    }
  }

  Future<bool> isMovieFavorite(Movie movie) async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();

      Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
      if (data == null || !data.containsKey('favorites')) {
        await _firestore.collection('users').doc(user.uid).set({'favorites': []}, SetOptions(merge: true));
        return false;
      }

      List<dynamic> favorites = data['favorites'] ?? [];
      return favorites.any((fav) => fav['id'] == movie.id);
    }
    return false;
  }

  Future<bool> isTvShowFavorite(TvShow tvShow) async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();

      Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
      if (data == null || !data.containsKey('favorite_tvShows')) {
        await _firestore.collection('users').doc(user.uid).set({'favorite_tvShows': []}, SetOptions(merge: true));
        return false;
      }

      List<dynamic> favorites = data['favorite_tvShows'] ?? [];
      return favorites.any((fav) => fav['id'] == tvShow.id);
    }
    return false;
  }

  Future<List<Movie>> getFavoriteMovies() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
      Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
      if (data != null && data.containsKey('favorites')) {
        List<dynamic> favorites = data['favorites'];
        print(favorites);
        return favorites.map((fav) => Movie.fromJson(fav as Map<String, dynamic>)).toList();
      }
    }
    return [];
  }

  Future<List<TvShow>> getFavoriteTvShows() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
      Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
      if (data != null && data.containsKey('favorite_tvShows')) {
        List<dynamic> favorites = data['favorite_tvShows'];
        print(favorites);
        return favorites.map((fav) => TvShow.fromJson(fav as Map<String, dynamic>)).toList();
      }
    }
    return [];
  }



}




