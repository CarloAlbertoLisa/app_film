class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final double rating;
  final String releaseDate;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.rating,
    required this.releaseDate,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: (json['id'] ?? 0) as int,
      title: (json['title'] ?? json['name'] ?? 'Titolo non disponibile').toString(),
      overview: (json['overview'] ?? 'Nessuna descrizione disponibile').toString(),
      posterPath: (json['poster_path'] ?? '').toString(),
      rating: (json['vote_average'] ?? 0).toDouble(),
      releaseDate: (json['release_date'] ?? json['first_air_date'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'overview': overview,
    'poster_path': posterPath,
    'vote_average': rating,
    'release_date': releaseDate,
  };

  String get year {
    if (releaseDate.length < 4) return '—';
    return releaseDate.substring(0, 4);
  }

  String get posterUrl {
    if (posterPath.isEmpty) return '';
    return 'https://image.tmdb.org/t/p/w500$posterPath';
  }
}