
class Movies {

  List<Movie> items = new List();

  Movies();

  Movies.fromJsonList( List<dynamic> jsonList ) {

    if ( jsonList == null ) return;

    for ( var item in jsonList ) {
      final movie = new Movie.fromJsonMap( item );
      items.add(movie);
    }

  }

}

class Movie {

  String uniqueId;

  String posterPath;
  bool video;
  double voteAverage;
  double popularity;
  int voteCount;
  String releaseDate;
  String title;
  bool adult;
  String backdropPath;
  String overview;
  List<int> genreIds;
  int id;
  String originalLanguage;
  String originalTitle;

  Movie({
    this.posterPath,
    this.video,
    this.voteAverage,
    this.popularity,
    this.voteCount,
    this.releaseDate,
    this.title,
    this.adult,
    this.backdropPath,
    this.overview,
    this.genreIds,
    this.id,
    this.originalLanguage,
    this.originalTitle,
  });

  Movie.fromJsonMap( Map<String,dynamic> json ) {

    posterPath        = json['poster_path'];
    video             = json['video'];
    voteAverage       = json['vote_average'] / 1;
    popularity        = json['popularity'] / 1;
    voteCount         = json['vote_count'];
    releaseDate       = json['release_date'];
    title             = json['title'];
    adult             = json['adult'];
    backdropPath      = json['backdrop_path'];
    overview          = json['overview'];
    genreIds          = json['genre_ids'].cast<int>();
    id                = json['id'];
    originalLanguage  = json['original_language'];
    originalTitle     = json['original_title'];

  }

  getPosterImg() {
    
    if ( posterPath == null ) {
      return 'https://cdn.iconscout.com/icon/free/png-256/no-image-1771002-1505134.png';
    } else {
      return 'https://image.tmdb.org/t/p/w500/$posterPath';
    }

  }

  getBackgroundImg() {
    
    if ( posterPath == null ) {
      return 'https://cdn.iconscout.com/icon/free/png-256/no-image-1771002-1505134.png';
    } else {
      return 'https://image.tmdb.org/t/p/w500/$backdropPath';
    }

  }

}
