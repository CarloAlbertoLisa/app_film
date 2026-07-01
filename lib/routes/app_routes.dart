import 'package:flutter/material.dart';

import '../pages/pages.dart';

class AppRoutes {
  static const home = '/';
  static const favorites = '/favorites';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final uri = Uri.parse(settings.name ?? '/');

    // home
    if (uri.path == '/') {
      return MaterialPageRoute(
        builder: (_) => const HomePage(),
        settings: settings,
      );
    }

    // preferiti
    if (uri.path == '/favorites') {
      return MaterialPageRoute(
        builder: (_) => const FavoritesPage(),
        settings: settings,
      );
    }

    // dettaglio film
    if (uri.pathSegments.length == 2 &&
        uri.pathSegments[0] == 'detail') {
      final movieId = int.tryParse(uri.pathSegments[1]);

      return MaterialPageRoute(
        builder: (_) => DetailPage(movieId: movieId),
        settings: settings,
      );
    }

    return MaterialPageRoute(
      builder: (_) => const HomePage(),
    );
  }
}