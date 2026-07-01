import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../routes/app_routes.dart';
import '../../widgets/movie_card.dart';
import '../controllers/controllers.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final movieController = context.watch<MovieController>();
    final favoriteController = context.watch<FavoriteController>();
    final themeController = context.watch<ThemeController>();
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: movieController.refresh,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: true,
                floating: true,
                elevation: 0,
                backgroundColor: colors.surface,
                title: const Text(
                  'Movie Explorer',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.favorite_rounded),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.favorites);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded),
                    onPressed: movieController.refresh,
                  ),
                  IconButton(
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: Icon(
                        themeController.isDark
                            ? Icons.dark_mode_rounded
                            : Icons.light_mode_rounded,
                        key: ValueKey(themeController.isDark),
                      ),
                    ),
                    onPressed: themeController.toggleTheme,
                  ),
                ],
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(72),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: colors.surfaceVariant.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextField(
                        onChanged: movieController.setSearchQuery,
                        decoration: InputDecoration(
                          hintText: 'Cerca film, attori, generi...',
                          prefixIcon: const Icon(Icons.search_rounded),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: colors.primary.withOpacity(0.08),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.local_movies_rounded, color: colors.primary),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            movieController.isLoading
                                ? 'Caricamento...'
                                : '${movieController.movies
                                .length} film disponibili',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 8)),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: _buildBody(movieController, favoriteController),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(MovieController movieController,
      FavoriteController favoriteController,) {
    if (movieController.isLoading) {
      return const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (movieController.errorMessage != null) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off_rounded, size: 56),
              const SizedBox(height: 10),
              Text(movieController.errorMessage!),
              const SizedBox(height: 10),
              FilledButton(
                onPressed: movieController.refresh,
                child: const Text('Riprova'),
              ),
            ],
          ),
        ),
      );
    }

    if (movieController.movies.isEmpty) {
      return const SliverFillRemaining(
        child: Center(child: Text('Nessun film trovato')),
      );
    }

    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          final movie = movieController.movies[index];
          final isFavorite = favoriteController.isFavorite(movie);

          return MovieCard(
            movie: movie,
            isFavorite: isFavorite,
            onTap: () {
              Navigator.pushNamed(
                context,
                '/detail/${movie.id}',
              );
            },
            onFavoriteTap: () => favoriteController.toggle(movie),
          );
        },
        childCount: movieController.movies.length,
      ),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.58,
      ),
    );
  }
}