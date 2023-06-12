class MovieDetailModel {
  final String posterPath;
  final String backdropPath;
  final String originalTitle;
  final String overview;
  final int runtime;
  final double voteAverage;
  final List<Map<String, dynamic>> genres;

  MovieDetailModel.fromJson(Map<String, dynamic> json)
      : posterPath = json['poster_path'],
        backdropPath = json['backdrop_path'],
        originalTitle = json['original_title'],
        overview = json['overview'],
        runtime = json['runtime'],
        voteAverage = json['vote_average'],
        genres = List.from(json['genres']);
}
