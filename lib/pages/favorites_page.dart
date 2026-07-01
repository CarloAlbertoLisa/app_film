import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/movie_card.dart';
import '../controllers/controllers.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoriteController>();
    final movieController = context.watch<MovieController>();
    final colors = Theme
        .of(context)
        .colorScheme;

    final favoriteMovies =
    favorites.getFavoriteMovies(movieController.movies);

    return Scaffold(
      backgroundColor: colors.surface,

      appBar: AppBar(
        title: const Text(
          'Preferiti',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: colors.surface,
        elevation: 0,
      ),
      body: favoriteMovies.isEmpty
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 440),
            padding: const EdgeInsets.all(26),
            decoration: BoxDecoration(
              color: colors.surfaceContainerHighest.withOpacity(0.35),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: colors.outlineVariant.withOpacity(0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.favorite_border_rounded,
                  size: 70,
                  color: colors.primary,
                ),
                const SizedBox(height: 14),
                const Text(
                  'Nessun preferito',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tocca il cuore su un film per salvarlo qui.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 18),
                FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Torna ai film'),
                ),
              ],
            ),
          ),
        ),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: favoriteMovies.length,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 220,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 0.58,
        ),
        itemBuilder: (context, index) {
          final movie = favoriteMovies[index];
          return MovieCard(
            movie: movie,
            isFavorite: true,
            onTap: () {
              Navigator.pushNamed(
                context,
                '/detail/${movie.id}',
              );
            },
            onFavoriteTap: () => favorites.toggle(movie),
          );
        },
      ),
    );
  }
}