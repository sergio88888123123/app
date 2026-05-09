import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/movie.dart';

class HttpMoviesService {
  HttpMoviesService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<Movie>> fetchMoviesFromApi() async {
    final url = Uri.parse('https://ghibliapi.vercel.app/films');
    final response = await _client.get(url);

    if (response.statusCode != 200) {
      throw Exception('Error al consultar la API HTTP: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body) as List<dynamic>;
    return decoded
        .map((item) => Movie.fromStudioGhibliApi(item as Map<String, dynamic>))
        .toList();
  }

  void dispose() {
    _client.close();
  }
}
