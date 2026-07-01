import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/controllers.dart';

class DetailPage extends StatelessWidget {
  final int? movieId;

  const DetailPage({
    super.key,
    required this.movieId,
  });

  @override
  Widget build(BuildContext context) {
    final movieController = context.watch<MovieController>();
    final favoriteController = context.watch<FavoriteController>();
    final colors = Theme
        .of(context)
        .colorScheme;

    final movie = movieController.movies
        .where((e) => e.id == movieId)
        .firstOrNull;

    if (movie == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isFavorite = favoriteController.isFavorite(movie);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 420,
            backgroundColor: colors.surface,
            actions: [
              IconButton(
                onPressed: () => favoriteController.toggle(movie),
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    key: ValueKey(isFavorite),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  _poster(movie.posterUrl, colors),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.2),
                          Colors.black.withOpacity(0.9),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 30,
                    child: Text(
                      movie.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _InfoRow(movie: movie),
                      const SizedBox(height: 18),
                      _SectionCard(
                        colors: colors,
                        title: 'Descrizione',
                        child: Text(
                          movie.overview,
                          style: TextStyle(
                            height: 1.5,
                            color: colors.onSurfaceVariant,
                            fontSize: 15.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      FilledButton.icon(
                        onPressed: () =>
                            favoriteController.toggle(movie),
                        icon: Icon(
                          isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                        ),
                        label: Text(
                          isFavorite
                              ? 'Rimosso dai preferiti'
                              : 'Aggiungi ai preferiti',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _poster(String url, ColorScheme colors) {
    if (url.isEmpty) {
      return Container(
        color: colors.surfaceContainerHighest,
        child: const Icon(Icons.movie_outlined, size: 80),
      );
    }

    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
    );
  }
}

class _InfoRow extends StatelessWidget {
  final dynamic movie;

  const _InfoRow({required this.movie});

  @override
  Widget build(BuildContext context) {
    final colors = Theme
        .of(context)
        .colorScheme;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _Chip(
          icon: Icons.star_rounded,
          text: movie.rating.toStringAsFixed(1),
          color: colors.primary,
        ),
        _Chip(
          icon: Icons.calendar_month_rounded,
          text: movie.releaseDate.isEmpty
              ? 'N/D'
              : movie.releaseDate,
          color: colors.secondary,
        ),
        _Chip(
          icon: Icons.local_movies_rounded,
          text: movie.year,
          color: colors.tertiary,
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _Chip({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: color.withOpacity(0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
          Text(text),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final ColorScheme colors;

  const _SectionCard({
    required this.title,
    required this.child,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: colors.outlineVariant.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}