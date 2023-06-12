import 'package:flutter/material.dart';

import '../screens/detail_screen.dart';

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
