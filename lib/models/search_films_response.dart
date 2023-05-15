// To parse this JSON data, do
//
//     final searchFilmResponse = searchFilmResponseFromMap(jsonString);

import 'dart:convert';

import 'package:peliculas/models/models.dart';

class SearchFilmResponse {
    SearchFilmResponse({
        required this.page,
        required this.results,
        required this.totalPages,
        required this.totalResults,
    });

    int page;
    List<Film> results;
    int totalPages;
    int totalResults;

    factory SearchFilmResponse.fromJson(String str) => SearchFilmResponse.fromMap(json.decode(str));

    factory SearchFilmResponse.fromMap(Map<String, dynamic> json) => SearchFilmResponse(
        page: json["page"],
        results: List<Film>.from(json["results"].map((x) => Film.fromMap(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
    );


}

