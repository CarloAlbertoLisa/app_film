import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/movie_model.dart';

class MovieServiceException implements Exception {
  final String message;

  MovieServiceException(this.message);

  @override
  String toString() => message;
}

class MovieService {
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String _apiKey = String.fromEnvironment('TMDB_API_KEY');

  Future<List<Movie>> fetchPopularMovies({int page = 1}) async {
    if (_apiKey.isEmpty) {
      throw MovieServiceException(
        'TMDB_API_KEY mancante. Avvia con --dart-define=TMDB_API_KEY=...',
      );
    }

    final uri = Uri.parse(
      '$_baseUrl/movie/popular?api_key=$_apiKey&language=it-IT&page=$page',
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode == 401) {
        throw MovieServiceException(
          'Chiave TMDB non valida o non autorizzata.',
        );
      }

      if (response.statusCode != 200) {
        throw MovieServiceException('Errore server (${response.statusCode}).');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final results = (data['results'] as List<dynamic>? ?? []);

      return results
          .map((e) => Movie.fromJson(e as Map<String, dynamic>))
          .toList();
    } on http.ClientException {
      throw MovieServiceException('Problema di rete o CORS. Riprova.');
    } catch (_) {
      throw MovieServiceException('Impossibile caricare i film.');
    }
  }
}
