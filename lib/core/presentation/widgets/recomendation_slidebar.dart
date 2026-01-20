import 'package:flutter/material.dart';
import 'package:turismo_app/core/data/datasources/firebase_place_datasource.dart';
import 'package:turismo_app/core/data/repositories/place_repository_impl.dart';
import 'package:turismo_app/core/domain/entities/place.dart';
import 'package:turismo_app/core/domain/repositories/place_repository.dart';
import 'package:turismo_app/core/presentation/widgets/tourist_place_tile.dart';
import 'package:turismo_app/core/utils/theme/theme_colors.dart';

class RecomendationSlidebar extends StatelessWidget {
  final String placeReferenceId;

  final PlaceRepository _repo = PlaceRepositoryImpl(datasource: FirebasePlaceDatasource());

  RecomendationSlidebar({
    super.key,
    required this.placeReferenceId,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Place>>(
      future: _repo.fetchLimitRecomendations(placeReferenceId, 3),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 120,
            child: Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        if (snapshot.hasError) {
          return const SizedBox(
            height: 120,
            child: Center(
              child: Text('Error al cargar recomendaciones'),
            ),
          );
        }

        final data = snapshot.data;

        if (data == null || data.isEmpty) {
          return const SizedBox(
            height: 120,
            child: Center(
              child: Text('Sin recomendaciones'),
            ),
          );
        }

        return SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: data.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final place = data[index];

              return Container(
                width: 260,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: ThemeColors.primaryGreen,
                    width: 1
                  ),
                  borderRadius: BorderRadius.circular(8)
                ),
                child: TouristPlaceTile(
                  place: place.toPlaceMin()!,
                  onTap: () => debugPrint(place.id),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
