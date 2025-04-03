import '../models/movie.dart';
import 'package:flutter/foundation.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:convert';
import 'dart:math';

class MovieProvider with ChangeNotifier {
  final LocalStorage storage;
  List<Movie> _movies = [];

  List<Movie> get movies => _movies;

  MovieProvider(this.storage) {
    _loadMoviesFromStorage();
  }

  void _loadMoviesFromStorage() async {
    var storedMovies = storage.getItem('movies');
    if (storedMovies != null) {
      _movies = List<Movie>.from(
          (storedMovies as List).map((item) => Movie.fromJson(item))
      );
      notifyListeners();
    }
  }

  void addMovie(Movie movie) {
    _movies.add(movie);
    _saveMoviesToStorage();
    notifyListeners();
  }

  void _saveMoviesToStorage() {
    storage.setItem(
        'movies', jsonEncode(_movies.map((e) => e.toJson()).toList())
    );
  }

  void addOrUpdateMovie(Movie movie) {
    int index = _movies.indexWhere((e) => e.id == movie.id);
    if (index != -1) {
      _movies[index] = movie;
    } else {
      _movies.add(movie);
    }
    _saveMoviesToStorage();
    notifyListeners();
  }

  void deleteMovie(String id) {
    _movies.removeWhere((movie) => movie.id == id);
    _saveMoviesToStorage();
    notifyListeners();
  }

  List randomSelectMovie() {
    var randomNumber = Random().nextInt(_movies.length);
    Movie movieSelected = _movies[randomNumber];
    List movieDetails = [movieSelected.movieTitle, movieSelected.description, movieSelected.url];

    return (movieDetails);
  }
}