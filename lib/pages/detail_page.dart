import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/favorite_controller.dart';
import '../../models/movie_model.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final movie = ModalRoute.of(context)!.settings.arguments as Movie;
    final favoriteController = context.watch<FavoriteController>();
    final isFavorite = favoriteController.isFavorite(movie);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 420,
            actions: [
              IconButton(
                onPressed: () => favoriteController.toggle(movie),
                icon: Icon(
                  isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (movie.posterUrl.isNotEmpty)
                    CachedNetworkImage(
                      imageUrl: movie.posterUrl,
                      fit: BoxFit.cover,
                    )
                  else
                    Container(
                      color: colors.surfaceVariant,
                      child: const Center(
                        child: Icon(Icons.movie_outlined, size: 72),
                      ),
                    ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.08),
                          Colors.black.withOpacity(0.78),
                        ],
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
                      Text(
                        movie.title,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _InfoChip(
                            icon: Icons.star_rounded,
                            label: movie.rating.toStringAsFixed(1),
                          ),
                          _InfoChip(
                            icon: Icons.calendar_month_rounded,
                            label: movie.releaseDate.isEmpty ? 'Data non disponibile' : movie.releaseDate,
                          ),
                          _InfoChip(
                            icon: Icons.local_movies_rounded,
                            label: movie.year,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: colors.surfaceVariant.withOpacity(0.22),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Descrizione',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              movie.overview,
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.55,
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      FilledButton.icon(
                        onPressed: () => favoriteController.toggle(movie),
                        icon: Icon(
                          isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        ),
                        label: Text(
                          isFavorite ? 'Rimuovi dai preferiti' : 'Aggiungi ai preferiti',
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
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
    );
  }
}