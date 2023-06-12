import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/api_service.dart';
import '../widgets/coming_soon_movie.dart';
import '../widgets/now_in_cinemas_movie.dart';
import '../widgets/popular_movie.dart';

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
}
