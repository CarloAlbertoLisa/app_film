import 'package:flutter/material.dart';

import '../models/movie_model.dart';
import '../services/movie_service.dart';

class MovieController extends ChangeNotifier {
  final MovieService _service = MovieService();

  final List<Movie> _allMovies = [];
  List<Movie> _filteredMovies = [];

  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  List<Movie> get movies => List.unmodifiable(_filteredMovies);

  Future<void> loadMovies() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final pages = await Future.wait([
        _service.fetchPopularMovies(page: 1),
        _service.fetchPopularMovies(page: 2),
        _service.fetchPopularMovies(page: 3),
      ]);

      final unique = <int, Movie>{};

      for (final pageMovies in pages) {
        for (final movie in pageMovies) {
          unique[movie.id] = movie;
        }
      }

      _allMovies
        ..clear()
        ..addAll(unique.values);

      _applyFilter();
    } catch (e) {
      _errorMessage = e.toString();
      _filteredMovies = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() => loadMovies();

  void setSearchQuery(String value) {
    _searchQuery = value.trim().toLowerCase();
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    if (_searchQuery.isEmpty) {
      _filteredMovies = List.from(_allMovies);
      return;
    }

    _filteredMovies = _allMovies.where((movie) {
      return movie.title.toLowerCase().contains(_searchQuery);
    }).toList();
  }
}