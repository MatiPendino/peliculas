
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas/helpers/debouncer.dart';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/models/search_films_response.dart';

class FilmsProvider extends ChangeNotifier{

  final String _baseUrl = 'api.themoviedb.org';
  final String _apiKey = 'c4019fba83354b2fe188c39e23a8e6fa';
  final String _language = 'en-ES';

  List<Film> onDisplayFilms = [];
  List<Film> popularFilms = [];
  Map<int, List<Cast>> filmsCast = {};

  int _popularPage = 0;

  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 500),
  );
  final StreamController<List<Film>> _suggestionsStreamController = StreamController.broadcast();
  Stream<List<Film>> get suggestionStream => _suggestionsStreamController.stream;

  FilmsProvider(){
    getOnDisplayMovies();
    getPopularFilms();
  }

  Future<String> _getJsonData(String endpoint, [int page = 1]) async{
    Uri url = Uri.https(_baseUrl, endpoint, {
      'api_key': _apiKey,
      'language': _language,
      'page': '$page'
    });

    // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url);
    return response.body;
  }

  getOnDisplayMovies() async{
    final jsonData = await _getJsonData('3/movie/now_playing');

    // Decoded data
    final responseMap = NowPlayingResponse.fromJson(jsonData);
    /* YA NO USO ESTA LÍNEA, YA QUE EL MÉTODO .fromJson REALIZA ESA ACCIÓN
    final responseMap = json.decode(response.body) as Map<String, dynamic>; */
    
    onDisplayFilms = responseMap.results;
    notifyListeners();
  }

  getPopularFilms() async {
    _popularPage ++;
    final jsonData = await _getJsonData('3/movie/popular', _popularPage);

    // Decoded data
    final responseMap = PopularResponse.fromJson(jsonData);
    /* YA NO USO ESTA LÍNEA, YA QUE EL MÉTODO .fromJson REALIZA ESA ACCIÓN
    final responseMap = json.decode(response.body) as Map<String, dynamic>; */
    
    popularFilms = [...popularFilms, ...responseMap.results];
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int filmId) async {

    if (filmsCast.containsKey(filmId)){
      return filmsCast[filmId]!;
    }

    final jsonData = await _getJsonData('3/movie/$filmId/credits');
    final creditsResponse = CreditsResponse.fromJson(jsonData);

    filmsCast[filmId] = creditsResponse.cast;

    return creditsResponse.cast;
  }

  Future<List<Film>> searchFilms(String query) async{
    
    Uri url = Uri.https(_baseUrl, "3/search/movie", {
      'api_key': _apiKey,
      'language': _language,
      'query': query
    });

     // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url);
    final searchFilmResponse = SearchFilmResponse.fromJson(response.body);

    return searchFilmResponse.results;
  }

  void getSuggestionsByQuery(String query){

    debouncer.value = '';
    debouncer.onValue = (value) async {
      final results = await searchFilms(value);
      _suggestionsStreamController.add(results);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      debouncer.value = query;
    });

    Future.delayed(const Duration(milliseconds: 301)).then((_) => timer.cancel());

  }

}