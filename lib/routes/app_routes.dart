import 'package:flutter/material.dart';
import '../pages/pages.dart';


class AppRoutes {
  static const splash = '/';
  static const home = '/home';
  static const detail = '/detail';
  static const favorites = '/favorites';

  static final routes = <String, WidgetBuilder>{
    splash: (_) => const SplashPage(),
    home: (_) => const HomePage(),
    detail: (_) => const DetailPage(),
    favorites: (_) => const FavoritesPage(),
  };
}