import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:movie_selector/models/movie.dart';
import 'package:movie_selector/pages/home.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class  AddMovieScreen extends StatefulWidget {
  final Movie? initialMovie;
  const AddMovieScreen({super.key, this.initialMovie});

  @override
  _AddMovieScreenState createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends State<AddMovieScreen> {
  late TextEditingController _titleController;
  late TextEditingController _idController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.initialMovie?.movieTitle ?? ''
    );
    _idController = TextEditingController(
      text: widget.initialMovie?.id ?? ''
    );
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)
          )
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            buildTextField(_titleController, 'Movie Title', TextInputType.text),
            buildTextField(_idController, 'IMDB ID', TextInputType.text),
            ElevatedButton(
                onPressed: _saveMovie,
                child: Text('Save Movie')
            )
          ],
        ),
      )
    );
  }

  void _saveMovie() {
    if(_titleController.text.isEmpty || _idController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all required fields')
        )
      );
      return;
    }

    String imdbId = _idController.text;
    String movieName = _titleController.text;
    //Add API
    Future <Map<String, String?>> fetchResponse(id) async {
      final response = await http.get(Uri.parse('https://api.themoviedb.org/3/find/$id?external_source=imdb_id'), headers: {
        'Authorization': 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlZmE1MTA1MTA1NDI5NjBlNjYzYmY5ZjkxMDhjMThkNiIsIm5iZiI6MTczODM3MTM1Mi4yMDIsInN1YiI6IjY3OWQ3MTE4YTU3OTA5NzAxYWNiMjk4MSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.7PWTMFZpKot5JTJHvQLg1dYBXXIGWHtqhhsiwftWUOA',
        'accept': 'application/json'
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['movie_results'] != null && data['movie_results'].isNotEmpty) {
          final description = data['movie_results'][0]['overview'];
          final url = 'https://image.tmdb.org/t/p/w500${data['movie_results'][0]['poster_path']}';
          return {'description': description, 'url': url};
        }
        final description = null;
        final url = null;
      return {'description': description, 'url': url};

      } else {
        final description = null;
        final url = null;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('IMDB ID is not valid')
          )
        );
        return {'description': description, 'url': url};
      }
    }

    void getMovieDetails(String imdbId, String movieName) async {
      Map<String, String?> movieDetails = await fetchResponse(imdbId);

      var description;
      var url;
      if (movieDetails['description'] != null) {
        description = movieDetails['description'];
      } else {
        description = 'No description found';
      }
      if (movieDetails['url'] != null) {
        url = movieDetails['url'];
      } else {
        url = 'No description found';
      }


      final movie = Movie(
          id: imdbId,
          movieTitle: movieName,
          description: description,
          url: url
      );

      Provider.of<MovieProvider>(context, listen: false).addOrUpdateMovie(movie);
      Navigator.pop(context);
    }

    getMovieDetails(imdbId, movieName);
  }

  Widget buildTextField(TextEditingController controller, String label, TextInputType type) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder()
        ),
        keyboardType: type,
      ),
    );
  }

}
