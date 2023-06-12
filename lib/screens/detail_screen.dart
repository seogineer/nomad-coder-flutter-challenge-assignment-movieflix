import 'package:flutter/material.dart';

import '../models/movie_detail.dart';
import '../services/api_service.dart';

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
    List<Widget> stars = getNotfilledStars();
    int countOfStars = (voteAverage / 2.0).round();
    for (int i = 0; i < countOfStars; i++) {
      stars[i] = const Icon(
        Icons.star_rounded,
        size: 25,
        color: Colors.amber,
      );
    }
    return stars;
  }

  List<Widget> getNotfilledStars() {
    return List.filled(
      5,
      const Icon(
        Icons.star_rounded,
        size: 25,
        color: Colors.white54,
      ),
    );
  }
}
