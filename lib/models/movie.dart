class Movie {
  String movieTitle;
  String id;
  String? url;
  String? description;

  Movie({
    required this.movieTitle,
    required this.id,
    required this.url,
    required this.description

  });

  //pulls from json
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      movieTitle: json['movieTitle'],
      id: json['id'],
      url: json['url'],
      description: json['description']
    );
  }

  //pushes to json
  Map<String, dynamic> toJson() {
    return {
      'movieTitle': movieTitle,
      'id': id,
      'url': url,
      'description': description
    };
  }
}