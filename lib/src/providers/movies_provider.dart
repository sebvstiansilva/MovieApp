import 'package:http/http.dart' as http;

import 'dart:convert';
import 'dart:async';

import 'package:movies/src/models/movie_model.dart';
import 'package:movies/src/models/actor_model.dart';

class MoviesProvider {

  String _apiKey    = '2e7ff8acb9e6a745d75ab15659fd3c04';
  String _url       = 'api.themoviedb.org';
  String _language  = 'en-US';

  int _popularsPage = 0;
  bool _loading     = false;

  List<Movie> _populars = new List();

  final _popularsStreamController = StreamController<List<Movie>>.broadcast();


  Function(List<Movie>) get popularsSink => _popularsStreamController.sink.add;

  Stream<List<Movie>> get popularsStream => _popularsStreamController.stream;

  void disposeStream() {

    _popularsStreamController?.close();

  }

  Future<List<Movie>> _processRespond( Uri url ) async {

    final resp = await http.get( url );
    final decodedData = json.decode( resp.body );

    final movies = new Movies.fromJsonList( decodedData['results'] );

    return movies.items;

  }

  Future<List<Movie>> getNowPlaying() async {

    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key'   : _apiKey,
      'language'  : _language 
    });

    return await _processRespond(url);

  }

  Future<List<Movie>> getPopular() async {

    if ( _loading ) return [];

    _loading = true;
    
    _popularsPage++;

    print('loading');

    final url = Uri.https( _url, '3/movie/popular', {
      'api_key'   : _apiKey,
      'language'  : _language,
      'page'      : _popularsPage.toString()
    });

    final resp = await _processRespond(url);

    _populars.addAll( resp );

    popularsSink( _populars );

    _loading = false;
    return resp;

  }

  Future<List<Actor>> getCast( String movieId ) async {
    
    final url = Uri.https(_url, '3/movie/$movieId/credits', {
      'api_key'   : _apiKey,
      'language'  : _language
    });

    final resp        = await http.get( url );
    final decodedData = json.decode( resp.body );

    final cast        = new Cast.fromJsonList( decodedData['cast'] );

    return cast.actors;
  }

  Future<List<Movie>> searchMovie( String query ) async {

    final url = Uri.https(_url, '3/search/movie', {
      'api_key'   : _apiKey,
      'language'  : _language,
      'query'     : query
    });

    return await _processRespond(url);

  }

}