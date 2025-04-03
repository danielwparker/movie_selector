import 'package:flutter/material.dart';
import 'package:movie_selector/pages/movie_viewer.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';

class  HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget build(BuildContext) {
    return Scaffold(
        body: SafeArea(
            child: Column(
              children: [
                Expanded(
                    child: Center(
                      child: ElevatedButton(
                          onPressed: _showRandomMovie,
                          child: Text('Select a Movie')
                      ),
                    )
                )
              ],
            )
        )
    );
  }

  void _showRandomMovie () {
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);
    List movieDetails = movieProvider.randomSelectMovie();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MovieViewer(movieDetails: movieDetails)
        )
    );
  }
}