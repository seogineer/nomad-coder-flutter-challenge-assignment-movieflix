import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final Future<List<MovieModel>> popularMovies = ApiService.getPopularMovies();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 90,
            ),
            const Row(
              children: [
                Text(
                  'Popular Movies',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            FutureBuilder(
              future: popularMovies,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SizedBox(
                    height: 200,
                    child: makePopularList(snapshot),
                  );
                }
                return const SizedBox(
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircularProgressIndicator(),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

ListView makePopularList(AsyncSnapshot<List<MovieModel>> snapshot) {
  return ListView.separated(
    scrollDirection: Axis.horizontal,
    itemCount: snapshot.data!.length,
    itemBuilder: (context, index) {
      var movie = snapshot.data![index];
      return PopularMovie(
        posterPath: movie.posterPath,
      );
    },
    separatorBuilder: (context, index) => const SizedBox(
      width: 20,
    ),
  );
}

class PopularMovie extends StatelessWidget {
  final String baseUrl = "https://image.tmdb.org/t/p/w500/";
  final String posterPath;

  const PopularMovie({
    super.key,
    required this.posterPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            blurRadius: 15,
            offset: const Offset(10, 10),
            color: Colors.black.withOpacity(0.5),
          ),
        ],
      ),
      child: Image.network(
        '$baseUrl$posterPath',
        fit: BoxFit.cover,
      ),
    );
  }
}

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
}

class MovieModel {
  final bool adult;
  final String backdropPath;
  final List<int> genreIds;
  final int id;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String posterPath;
  final String releaseDate;
  final String title;
  final bool video;
  final double voteAverage;
  final int voteCount;

  MovieModel.fromJson(Map<String, dynamic> json)
      : adult = json['adult'],
        backdropPath = json['backdrop_path'],
        genreIds = List<int>.from(json['genre_ids']),
        id = json['id'],
        originalLanguage = json['original_language'],
        originalTitle = json['original_title'],
        overview = json['overview'],
        popularity = json['popularity'],
        posterPath = json['poster_path'],
        releaseDate = json['release_date'],
        title = json['title'],
        video = json['video'],
        voteAverage = json['vote_average'],
        voteCount = json['vote_count'];
}
