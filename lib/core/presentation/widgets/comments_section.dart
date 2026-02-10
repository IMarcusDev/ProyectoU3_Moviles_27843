import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../data/repositories/rating_repository_provider.dart';
import '../../domain/entities/rating.dart';
import '../../utils/theme/theme_colors.dart';
import '../../utils/theme/app_spacing.dart';

class CommentsSection extends ConsumerWidget {
  final String placeId;

  const CommentsSection({
    super.key,
    required this.placeId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    timeago.setLocaleMessages('es', timeago.EsMessages());

    return FutureBuilder<List<Rating>>(
      future: ref.read(ratingRepositoryProvider).getRatingsForPlace(placeId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.xl),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: ThemeColors.primaryGreen,
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                const Icon(
                  Icons.error_outline,
                  color: ThemeColors.error,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  'Error cargando comentarios',
                  style: const TextStyle(
                    color: ThemeColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (snapshot.error != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${snapshot.error}',
                    style: TextStyle(
                      color: ThemeColors.textSecondary.withValues(alpha: 0.7),
                      fontSize: 11,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          );
        }

        final ratings = snapshot.data ?? [];

        if (ratings.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: ThemeColors.primaryGreen.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.rate_review_outlined,
                  size: 48,
                  color: ThemeColors.textSecondary.withValues(alpha: 0.5),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Sin comentarios aún',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: ThemeColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '¡Sé el primero en calificar este lugar!',
                  style: TextStyle(
                    fontSize: 12,
                    color: ThemeColors.textSecondary.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          );
        }

        // Calcular promedio
        final avgRating = ratings.fold<double>(
          0.0,
          (sum, r) => sum + r.stars,
        ) / ratings.length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con promedio
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: ThemeColors.primaryGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // Promedio grande
                  Column(
                    children: [
                      Text(
                        avgRating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: ThemeColors.primaryGreen,
                        ),
                      ),
                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            index < avgRating.round()
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            size: 16,
                            color: ThemeColors.primaryGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: AppSpacing.lg),

                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${ratings.length} ${ratings.length == 1 ? 'calificación' : 'calificaciones'}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: ThemeColors.textPrimary,
                          ),
                        ),
                        Text(
                          '${ratings.where((r) => r.comment != null && r.comment!.isNotEmpty).length} con comentario',
                          style: TextStyle(
                            fontSize: 12,
                            color: ThemeColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Lista de comentarios
            ...ratings.map((rating) => _buildCommentCard(rating)),
          ],
        );
      },
    );
  }

  Widget _buildCommentCard(Rating rating) {
    final hasComment = rating.comment != null && rating.comment!.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ThemeColors.primaryGreen.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: usuario + rating
          Row(
            children: [
              // Avatar
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: ThemeColors.primaryGreen.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    rating.userName.isNotEmpty
                        ? rating.userName[0].toUpperCase()
                        : 'U',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: ThemeColors.primaryGreen,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),

              // Nombre y fecha
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rating.userName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: ThemeColors.textPrimary,
                      ),
                    ),
                    Text(
                      timeago.format(rating.createdAt, locale: 'es'),
                      style: TextStyle(
                        fontSize: 11,
                        color: ThemeColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Estrellas
              Row(
                children: List.generate(
                  rating.stars,
                  (index) => const Icon(
                    Icons.star_rounded,
                    size: 16,
                    color: Colors.amber,
                  ),
                ),
              ),
            ],
          ),

          // Comentario
          if (hasComment) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              rating.comment!,
              style: const TextStyle(
                fontSize: 13,
                height: 1.4,
                color: ThemeColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
