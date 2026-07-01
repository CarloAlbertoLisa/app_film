import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/movie_model.dart';

class FavoriteController extends ChangeNotifier {
  static const _storageKey = 'favorites';

  final Set<int> _favorites = {};

  Set<int> get favorites => _favorites;

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    _favorites
      ..clear()
      ..addAll(
        prefs
            .getStringList(_storageKey)
            ?.map(int.parse)
            .toList() ??
            [],
      );

    notifyListeners();
  }

  bool isFavorite(Movie movie) {
    return _favorites.contains(movie.id);
  }

  Future<void> toggle(Movie movie) async {
    final prefs = await SharedPreferences.getInstance();

    if (_favorites.contains(movie.id)) {
      _favorites.remove(movie.id);
    } else {
      _favorites.add(movie.id);
    }

    await prefs.setStringList(
      _storageKey,
      _favorites.map((e) => e.toString()).toList(),
    );

    notifyListeners();
  }

  List<Movie> getFavoriteMovies(List<Movie> movies) {
    return movies
        .where((movie) => _favorites.contains(movie.id))
        .toList();
  }
}