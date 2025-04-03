import 'package:flutter/material.dart';

class MovieViewer extends StatelessWidget {
  final List movieDetails; // Movie details received from HomeScreen

  const MovieViewer({Key? key, required this.movieDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: <Widget>[
                Image.network(movieDetails[2],
                  width: 180,
                  height: 200,),
                Flexible(
                  child: Text(
                    '${movieDetails[0]}',
                    style: const TextStyle(fontSize: 20),
                    textAlign: TextAlign.left,// Movie title,
                  )
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              '${movieDetails[1]}', // Movie description
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}