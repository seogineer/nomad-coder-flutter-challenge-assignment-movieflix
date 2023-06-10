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
  final Future<List<MovieModel>> nowInCinemas = ApiService.getNowInCinemas();
  final Future<List<MovieModel>> comingSoon = ApiService.getComingSoon();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 120,
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
              ),
              const SizedBox(
                height: 30,
              ),
              const Row(
                children: [
                  Text(
                    'Now in Cinemas',
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
                future: nowInCinemas,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SizedBox(
                      height: 230,
                      child: makeNowInCinemasList(snapshot),
                    );
                  }
                  return const SizedBox(
                    height: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircularProgressIndicator(),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 30,
              ),
              const Row(
                children: [
                  Text(
                    'Coming Soon',
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
                future: comingSoon,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SizedBox(
                      height: 230,
                      child: makeComingSoonList(snapshot),
                    );
                  }
                  return const SizedBox(
                    height: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircularProgressIndicator(),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailScreen extends StatefulWidget {
  final int id;

  const DetailScreen({
    super.key,
    required this.id,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final String baseUrl = "https://image.tmdb.org/t/p/w500/";
  late Future<MovieDetailModel> movie;

  @override
  void initState() {
    super.initState();
    movie = ApiService.getMovieById(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Back to list',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: false,
        leading: const BackButton(
          color: Colors.white,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      extendBodyBehindAppBar: true,
      body: FutureBuilder(
        future: movie,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var movie = snapshot.data!;
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage('$baseUrl${movie.posterPath}'),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Container(),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Flexible(
                        flex: 5,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                movie.originalTitle,
                                style: const TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                children: displayStar(movie.voteAverage),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 30),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      Text(
                                        displayRuntime(movie.runtime),
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const Text(
                                        ' | ',
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.white),
                                      ),
                                      Text(
                                        genreBuilder(movie.genres),
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Storyline',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              movie.overview,
                              style: const TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 40,
                          right: 40,
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            const snackBar = SnackBar(
                              content: Text('Buy Ticket!'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            fixedSize: const Size.fromHeight(60),
                            backgroundColor: Colors.amber,
                          ),
                          child: const Text(
                            'Buy ticket',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  String displayRuntime(int runtime) {
    String hour = (runtime / 60).floor().toString();
    String minute = (runtime % 60).toString();
    return '${hour}h ${minute}min';
  }

  String genreBuilder(List<Map<String, dynamic>> genres) {
    final buffer = StringBuffer('');
    String last = genres.last['name'];
    for (var genre in genres) {
      buffer.write(genre['name']);
      if (genre['name'] == last) {
        continue;
      }
      buffer.write(', ');
    }
    return buffer.toString();
  }

  List<Widget> displayStar(double voteAverage) {
    List<Widget> stars = [];
    int filledStar = (voteAverage / 2.0).round();
    int notFilledStar = 5 - filledStar;
    for (int i = 0; i < filledStar; i++) {
      stars.add(const Icon(
        Icons.star_rounded,
        size: 25,
        color: Colors.amber,
      ));
    }
    for (int i = 0; i < notFilledStar; i++) {
      stars.add(const Icon(
        Icons.star_rounded,
        size: 25,
        color: Colors.white54,
      ));
    }
    return stars;
  }
}

ListView makeComingSoonList(AsyncSnapshot<List<MovieModel>> snapshot) {
  return ListView.separated(
    scrollDirection: Axis.horizontal,
    itemCount: snapshot.data!.length,
    itemBuilder: (context, index) {
      var movie = snapshot.data![index];
      return ComingSoonMovie(
        posterPath: movie.posterPath,
        title: movie.title,
        id: movie.id,
      );
    },
    separatorBuilder: (context, index) => const SizedBox(
      width: 20,
    ),
  );
}

class ComingSoonMovie extends StatelessWidget {
  final String baseUrl = "https://image.tmdb.org/t/p/w500/";
  final String posterPath;
  final String title;
  final int id;

  const ComingSoonMovie({
    super.key,
    required this.posterPath,
    required this.title,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(
              id: id,
            ),
            fullscreenDialog: false,
          ),
        );
      },
      child: Column(
        children: [
          Container(
            width: 150,
            height: 150,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Image.network(
              '$baseUrl$posterPath',
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 150,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.clip,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

ListView makeNowInCinemasList(AsyncSnapshot<List<MovieModel>> snapshot) {
  return ListView.separated(
    scrollDirection: Axis.horizontal,
    itemCount: snapshot.data!.length,
    itemBuilder: (context, index) {
      var movie = snapshot.data![index];
      return NowInCinemasMovie(
        posterPath: movie.posterPath,
        title: movie.title,
        id: movie.id,
      );
    },
    separatorBuilder: (context, index) => const SizedBox(
      width: 20,
    ),
  );
}

class NowInCinemasMovie extends StatelessWidget {
  final String baseUrl = "https://image.tmdb.org/t/p/w500/";
  final String posterPath;
  final String title;
  final int id;

  const NowInCinemasMovie({
    super.key,
    required this.posterPath,
    required this.title,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(
              id: id,
            ),
            fullscreenDialog: false,
          ),
        );
      },
      child: Column(
        children: [
          Container(
            width: 150,
            height: 150,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Image.network(
              '$baseUrl$posterPath',
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 150,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.clip,
              ),
            ),
          ),
        ],
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
        id: movie.id,
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
  final int id;

  const PopularMovie({
    super.key,
    required this.posterPath,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(
              id: id,
            ),
            fullscreenDialog: false,
          ),
        );
      },
      child: Container(
        width: 300,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Image.network(
          '$baseUrl$posterPath',
          fit: BoxFit.cover,
        ),
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
        voteAverage = double.parse(json['vote_average'].toString()),
        voteCount = json['vote_count'];
}
