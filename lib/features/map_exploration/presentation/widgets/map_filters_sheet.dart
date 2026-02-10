import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turismo_app/core/utils/theme/theme_colors.dart';
import 'package:turismo_app/core/utils/theme/app_spacing.dart';
import 'package:turismo_app/features/map_exploration/presentation/providers/map_providers.dart';

class MapFiltersSheet extends ConsumerWidget {
  const MapFiltersSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final maxDistance = ref.watch(maxDistanceProvider);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Título
          const Text(
            'Filtros Avanzados',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: ThemeColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Filtro de distancia
          _buildSection(
            'Distancia Máxima',
            Icons.my_location,
            child: Column(
              children: [
                Slider(
                  value: maxDistance ?? 50.0,
                  min: 1.0,
                  max: 50.0,
                  divisions: 49,
                  activeColor: ThemeColors.primaryGreen,
                  label: maxDistance == null
                      ? 'Sin límite'
                      : '${maxDistance.toStringAsFixed(0)} km',
                  onChanged: (value) {
                    ref.read(maxDistanceProvider.notifier).state = value;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      maxDistance == null
                          ? 'Sin límite'
                          : 'Hasta ${maxDistance.toStringAsFixed(0)} km',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: ThemeColors.primaryGreen,
                      ),
                    ),
                    if (maxDistance != null)
                      TextButton(
                        onPressed: () {
                          ref.read(maxDistanceProvider.notifier).state = null;
                        },
                        child: const Text('Quitar límite'),
                      ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Filtro de calificación
          _buildSection(
            'Calificación Mínima',
            Icons.star,
            child: Wrap(
              spacing: 8,
              children: [
                _buildRatingChip(ref, null, 'Todas'),
                _buildRatingChip(ref, 3.0, '3+ ⭐'),
                _buildRatingChip(ref, 4.0, '4+ ⭐'),
                _buildRatingChip(ref, 4.5, '4.5+ ⭐'),
                _buildRatingChip(ref, 5.0, '5 ⭐'),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Botón limpiar filtros
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                ref.read(maxDistanceProvider.notifier).state = null;
                ref.read(minRatingProvider.notifier).state = null;
                ref.read(searchQueryProvider.notifier).state = '';
                Navigator.pop(context);
              },
              icon: const Icon(Icons.clear_all),
              label: const Text('Limpiar todos los filtros'),
              style: OutlinedButton.styleFrom(
                foregroundColor: ThemeColors.error,
                side: const BorderSide(color: ThemeColors.error),
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, {required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: ThemeColors.primaryGreen),
            const SizedBox(width: AppSpacing.sm),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: ThemeColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        child,
      ],
    );
  }

  Widget _buildRatingChip(WidgetRef ref, double? rating, String label) {
    final currentRating = ref.watch(minRatingProvider);
    final isSelected = currentRating == rating;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        ref.read(minRatingProvider.notifier).state = rating;
      },
      selectedColor: ThemeColors.primaryGreen,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : ThemeColors.textPrimary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }
}
