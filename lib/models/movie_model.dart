class Movie {
  final int id;
  final String title;
  final String poster;
  final String releaseDate;
  final double rating;
  final String overview;
  final List<int> genreIds;

  Movie({
    required this.id,
    required this.title,
    required this.poster,
    required this.releaseDate,
    required this.rating,
    required this.overview,
    required this.genreIds,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    const String imageUrlBase = 'https://image.tmdb.org/t/p/w500';

    return Movie(
      id: json['id'],
      title: json['title'],
      poster: json['poster_path'] != null ? '$imageUrlBase${json['poster_path']}' : '', // Construct full URL
      releaseDate: json['release_date'] ?? '',
      rating: (json['vote_average'] as num).toDouble(),
      overview: json['overview'] ?? '',
      genreIds: List<int>.from(json['genre_ids'] ?? []),
    );
  }
}

