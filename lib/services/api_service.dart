import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import '../models/movie_detail.dart';

class ApiService {
  static const String baseUrl = "https://movies-api.nomadcoders.workers.dev";

  static Future<List<MovieModel>> getPopularMovies() async {
    List<MovieModel> popularMovieInstances = [];
    final url = Uri.parse('$baseUrl/popular');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final dynamic movies = jsonDecode(response.body);
      for (var movie in movies["results"]) {
        popularMovieInstances.add(MovieModel.fromJson(movie));
      }
      return popularMovieInstances;
    }
    throw Error();
  }

  static Future<List<MovieModel>> getNowInCinemas() async {
    List<MovieModel> nowInCinemas = [];
    final url = Uri.parse('$baseUrl/now-playing');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final dynamic movies = jsonDecode(response.body);
      for (var movie in movies["results"]) {
        nowInCinemas.add(MovieModel.fromJson(movie));
      }
      return nowInCinemas;
    }
    throw Error();
  }

  static Future<List<MovieModel>> getComingSoon() async {
    List<MovieModel> comingSoons = [];
    final url = Uri.parse('$baseUrl/coming-soon');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final dynamic movies = jsonDecode(response.body);
      for (var movie in movies["results"]) {
        comingSoons.add(MovieModel.fromJson(movie));
      }
      return comingSoons;
    }
    throw Error();
  }

  static Future<MovieDetailModel> getMovieById(int id) async {
    final url = Uri.parse('$baseUrl/movie?id=$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final dynamic movie = jsonDecode(response.body);
      return MovieDetailModel.fromJson(movie);
    }
    throw Error();
  }
}
