import 'package:flutter/material.dart';

import '../screens/detail_screen.dart';

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
