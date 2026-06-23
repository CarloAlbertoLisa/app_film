import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/favorite_controller.dart';
import '../../controllers/movie_controller.dart';
import '../../routes/app_routes.dart';
import '../../widgets/movie_card.dart';

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
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

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
                title: const Text('Movie Explorer'),
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
                  SizedBox(width: size.height * 0.02),
                ],
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(78),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                    child: TextField(
                      onChanged: movieController.setSearchQuery,
                      decoration: const InputDecoration(
                        hintText: 'Cerca un film...',
                        prefixIcon: Icon(Icons.search_rounded),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: colors.surfaceVariant.withOpacity(0.22),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.local_movies_rounded, color: colors.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            movieController.isLoading
                                ? 'Caricamento film in corso...'
                                : '${movieController.movies.length} film disponibili',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
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

  Widget _buildBody(
      MovieController movieController,
      FavoriteController favoriteController,
      ) {
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
              const Icon(Icons.wifi_off_rounded, size: 60),
              const SizedBox(height: 12),
              Text(
                movieController.errorMessage!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
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
        child: Center(
          child: Text('Nessun film trovato'),
        ),
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
                AppRoutes.detail,
                arguments: movie,
              );
            },
            onFavoriteTap: () => favoriteController.toggle(movie),
          );
        },
        childCount: movieController.movies.length,
      ),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 240,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.62,
      ),
    );
  }
}