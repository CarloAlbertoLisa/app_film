import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/movie_model.dart';

class FavoriteController extends ChangeNotifier {
  static const _storageKey = 'favorite_movies';

  final List<Movie> _favorites = [];
  bool _loaded = false;

  List<Movie> get favorites => List.unmodifiable(_favorites);

  Future<void> loadFavorites() async {
    if (_loaded) return;

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_storageKey) ?? [];

    _favorites
      ..clear()
      ..addAll(
        raw.map((item) => Movie.fromJson(jsonDecode(item) as Map<String, dynamic>)),
      );

    _loaded = true;
    notifyListeners();
  }

  bool isFavorite(Movie movie) {
    return _favorites.any((item) => item.id == movie.id);
  }

  Future<void> toggle(Movie movie) async {
    final prefs = await SharedPreferences.getInstance();

    if (isFavorite(movie)) {
      _favorites.removeWhere((item) => item.id == movie.id);
    } else {
      _favorites.add(movie);
    }

    await prefs.setStringList(
      _storageKey,
      _favorites.map((m) => jsonEncode(m.toJson())).toList(),
    );

    notifyListeners();
  }
}