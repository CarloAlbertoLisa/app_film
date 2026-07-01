import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/movie_model.dart';

class MovieCard extends StatefulWidget {
  final Movie movie;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;
  final bool isFavorite;

  const MovieCard({
    super.key,
    required this.movie,
    required this.onTap,
    required this.onFavoriteTap,
    required this.isFavorite,
  });

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 180),
        scale: _hover ? 1.04 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: colors.surface,
            border: Border.all(
              color: _hover
                  ? colors.primary.withOpacity(0.5)
                  : colors.outlineVariant.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_hover ? 0.25 : 0.12),
                blurRadius: _hover ? 18 : 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: InkWell(
              onTap: widget.onTap,
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        _poster(colors),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          color: _hover
                              ? Colors.black.withOpacity(0.15)
                              : Colors.transparent,
                        ),

                        Positioned(
                          top: 10,
                          right: 10,
                          child: GestureDetector(
                            onTap: widget.onFavoriteTap,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(
                                  _hover ? 0.6 : 0.4,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                widget.isFavorite
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),

                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.85),
                                ],
                              ),
                            ),
                            child: Text(
                              widget.movie.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.star_rounded,
                            size: 16, color: colors.primary),
                        const SizedBox(width: 4),
                        Text(widget.movie.rating.toStringAsFixed(1)),
                        const Spacer(),
                        Text(
                          widget.movie.year,
                          style: TextStyle(
                            color: colors.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _poster(ColorScheme colors) {
    if (widget.movie.posterUrl.isEmpty) {
      return Container(
        color: colors.surfaceContainerHighest.withOpacity(0.4),
        child: const Icon(Icons.movie_outlined, size: 40),
      );
    }

    return CachedNetworkImage(
      imageUrl: widget.movie.posterUrl,
      fit: BoxFit.cover,
      placeholder: (_, __) => Container(
        color: colors.surfaceContainerHighest.withOpacity(0.4),
        child: const Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (_, __, ___) => Container(
        color: colors.surfaceContainerHighest.withOpacity(0.4),
        child: const Icon(Icons.broken_image_outlined),
      ),
    );
  }
}