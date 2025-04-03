import 'package:flutter/material.dart';
import 'package:movie_selector/pages/add_movie.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import 'package:movie_selector/pages/movie_viewer.dart';

class MovieListScreen extends StatelessWidget {
  const MovieListScreen({super.key});
  @override

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<MovieProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: provider.movies.length,
            itemExtent: 75,
            itemBuilder: (context, index) {
              final movie = provider.movies[index];
              return ListTile(
                onTap: () {
                  List movieDetails = [movie.movieTitle, movie.description, movie.url];
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieViewer(movieDetails: movieDetails)
                    )
                  );
                },
                leading: SizedBox(
                  height: 100,
                  child: Image.network('${movie.url}')
                ),
                title: Text('${movie.movieTitle}'),
                trailing: FloatingActionButton(
                  onPressed: () {
                    Provider.of<MovieProvider>(context, listen: false).deleteMovie(movie.id);
                  },
                  child: Icon(Icons.delete),
                ),
              );
            }
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddMovieScreen()
            )
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}