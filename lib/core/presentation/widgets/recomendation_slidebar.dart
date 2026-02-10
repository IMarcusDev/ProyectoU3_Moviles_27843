import 'package:flutter/material.dart';
import 'package:turismo_app/core/data/datasources/firebase_place_datasource.dart';
import 'package:turismo_app/core/data/repositories/place_repository_impl.dart';
import 'package:turismo_app/core/domain/entities/place.dart';
import 'package:turismo_app/core/domain/repositories/place_repository.dart';
import 'package:turismo_app/core/presentation/widgets/recommendation_tile.dart';
import 'package:turismo_app/core/presentation/widgets/tourist_place_panel.dart';
import 'package:turismo_app/core/utils/theme/theme_colors.dart';

class RecomendationSlidebar extends StatefulWidget {
  final String placeReferenceId;

  const RecomendationSlidebar({
    super.key,
    required this.placeReferenceId,
  });

  @override
  State<RecomendationSlidebar> createState() => _RecomendationSlidebarState();
}

class _RecomendationSlidebarState extends State<RecomendationSlidebar> {
  final PlaceRepository _repo = PlaceRepositoryImpl(datasource: FirebasePlaceDatasource());
  late Future<List<Place>> _recommendationsFuture;

  @override
  void initState() {
    super.initState();
    // Cachear el Future para evitar recargas constantes
    _recommendationsFuture = _repo.fetchLimitRecomendations(widget.placeReferenceId, 3);
  }

  void _openPlacePanel(Place place) {
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TouristPlacePanel(place: place),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Place>>(
      future: _recommendationsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 120,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: ThemeColors.primaryGreen,
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return const SizedBox(
            height: 120,
            child: Center(
              child: Text(
                'Error al cargar recomendaciones',
                style: TextStyle(color: ThemeColors.textSecondary),
              ),
            ),
          );
        }

        final data = snapshot.data;

        if (data == null || data.isEmpty) {
          return const SizedBox(
            height: 120,
            child: Center(
              child: Text(
                'Sin recomendaciones disponibles',
                style: TextStyle(color: ThemeColors.textSecondary),
              ),
            ),
          );
        }

        return SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: data.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final place = data[index];

              return SizedBox(
                width: 280,
                child: RecommendationTile(
                  place: place,
                  onTap: () => _openPlacePanel(place),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
