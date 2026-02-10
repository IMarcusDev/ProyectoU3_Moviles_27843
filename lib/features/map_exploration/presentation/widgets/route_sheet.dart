import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:turismo_app/core/utils/theme/theme_colors.dart';
import 'package:turismo_app/core/utils/theme/app_spacing.dart';
import '../../domain/entities/tourist_place.dart';
import '../providers/map_providers.dart';
import 'package:turismo_app/core/domain/entities/place.dart';
import 'package:turismo_app/core/domain/entities/preferences.dart';
import 'package:turismo_app/core/presentation/widgets/tourist_place_panel.dart';

class RouteSheet extends ConsumerWidget {
  final List<TouristPlace> route;
  final Position userLocation;

  const RouteSheet({
    super.key,
    required this.route,
    required this.userLocation,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routeService = ref.watch(routeServiceProvider);
    final totalDistance = routeService.calculateTotalDistance(
      route: route,
      userLocation: userLocation,
    );
    final estimatedDuration = routeService.estimateRouteDuration(
      route: route,
      userLocation: userLocation,
    );

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
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
          const SizedBox(height: AppSpacing.lg),

          // Título y botón cerrar
          Row(
            children: [
              const Icon(
                Icons.route,
                color: ThemeColors.primaryGreen,
                size: 28,
              ),
              const SizedBox(width: AppSpacing.sm),
              const Expanded(
                child: Text(
                  'Ruta Turística',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: ThemeColors.textPrimary,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  ref.read(generatedRouteProvider.notifier).state = null;
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
                color: ThemeColors.textSecondary,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Info de la ruta
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: ThemeColors.primaryGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _buildInfoItem(
                  Icons.place,
                  '${route.length} lugares',
                ),
                const SizedBox(width: AppSpacing.lg),
                _buildInfoItem(
                  Icons.straighten,
                  '${totalDistance.toStringAsFixed(1)} km',
                ),
                const SizedBox(width: AppSpacing.lg),
                _buildInfoItem(
                  Icons.access_time,
                  _formatDuration(estimatedDuration),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Lista de lugares
          Expanded(
            child: ListView.builder(
              itemCount: route.length,
              itemBuilder: (context, index) {
                final place = route[index];
                final isFirst = index == 0;
                final isLast = index == route.length - 1;

                // Calcular distancia desde punto anterior
                double distanceFromPrevious = 0;
                if (isFirst) {
                  distanceFromPrevious = Geolocator.distanceBetween(
                    userLocation.latitude,
                    userLocation.longitude,
                    place.latitude,
                    place.longitude,
                  ) / 1000;
                } else {
                  final previousPlace = route[index - 1];
                  distanceFromPrevious = Geolocator.distanceBetween(
                    previousPlace.latitude,
                    previousPlace.longitude,
                    place.latitude,
                    place.longitude,
                  ) / 1000;
                }

                return _buildRouteItem(
                  context,
                  ref,
                  place,
                  index + 1,
                  distanceFromPrevious,
                  isLast,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: ThemeColors.primaryGreen,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: ThemeColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildRouteItem(
    BuildContext context,
    WidgetRef ref,
    TouristPlace place,
    int number,
    double distance,
    bool isLast,
  ) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            // Convertir TouristPlace a Place para usar el panel
            final convertedPlace = Place(
              id: place.id,
              name: place.name,
              description: place.description,
              latitude: place.latitude,
              longitude: place.longitude,
              vector: Preferences(
                hotel: place.interestVector['hotel'] ?? 0.0,
                gastronomy: place.interestVector['gastronomy'] ?? 0.0,
                nature: place.interestVector['nature'] ?? 0.0,
                culture: place.interestVector['culture'] ?? 0.0,
              ),
            );

            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => TouristPlacePanel(place: convertedPlace),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: ThemeColors.primaryGreen.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                // Número de parada
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: ThemeColors.primaryGreen,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$number',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),

                // Info del lugar
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        place.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: ThemeColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(
                            Icons.navigation,
                            size: 12,
                            color: ThemeColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${distance.toStringAsFixed(1)} km',
                            style: const TextStyle(
                              fontSize: 12,
                              color: ThemeColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Icon(
                            Icons.star,
                            size: 12,
                            color: Colors.amber[700],
                          ),
                          const SizedBox(width: 2),
                          Text(
                            place.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 12,
                              color: ThemeColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Icono chevron
                const Icon(
                  Icons.chevron_right,
                  color: ThemeColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Row(
              children: [
                const SizedBox(width: 18),
                Container(
                  width: 2,
                  height: 20,
                  color: ThemeColors.primaryGreen.withValues(alpha: 0.3),
                ),
                const SizedBox(width: AppSpacing.sm),
                Icon(
                  Icons.arrow_downward,
                  size: 16,
                  color: ThemeColors.primaryGreen.withValues(alpha: 0.5),
                ),
              ],
            ),
          )
        else
          const SizedBox(height: AppSpacing.md),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
