class TvShow {
  final int id;
  final String name;
  final String poster;
  final String firstAirDate;
  final double rating;
  final String overview;
  final List<int> genreIds;

  TvShow({
    required this.id,
    required this.name,
    required this.poster,
    required this.firstAirDate,
    required this.rating,
    required this.overview,
    required this.genreIds,
  });

  factory TvShow.fromJson(Map<String, dynamic> json) {
    const String imageUrlBase = 'https://image.tmdb.org/t/p/w500';

    return TvShow(
      id: json['id'],
      name: json['name'],
      poster: json['poster_path'] != null ? '$imageUrlBase${json['poster_path']}' : '',
      firstAirDate: json['first_air_date'] ?? '',
      rating: (json['vote_average'] as num).toDouble(),
      overview: json['overview'] ?? '',
      genreIds: List<int>.from(json['genre_ids'] ?? []),
    );
  }
}
