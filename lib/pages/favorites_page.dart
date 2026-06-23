import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/favorite_controller.dart';
import '../../routes/app_routes.dart';
import '../../widgets/movie_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoriteController>();
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferiti'),
      ),
      body: favorites.favorites.isEmpty
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colors.surfaceVariant.withOpacity(0.22),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.favorite_border_rounded,
                  size: 64,
                  color: colors.primary,
                ),
                const SizedBox(height: 14),
                const Text(
                  'Nessun preferito salvato',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tocca il cuore su un film per aggiungerlo qui.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 18),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Torna ai film'),
                ),
              ],
            ),
          ),
        ),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: favorites.favorites.length,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 240,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.62,
        ),
        itemBuilder: (context, index) {
          final movie = favorites.favorites[index];

          return MovieCard(
            movie: movie,
            isFavorite: true,
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.detail,
                arguments: movie,
              );
            },
            onFavoriteTap: () => favorites.toggle(movie),
          );
        },
      ),
    );
  }
}