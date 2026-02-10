import 'package:flutter/material.dart';
import '../../domain/entities/tourist_place.dart';
import 'package:turismo_app/core/domain/entities/place.dart';
import 'package:turismo_app/core/domain/entities/preferences.dart';
import 'package:turismo_app/core/presentation/widgets/tourist_place_panel.dart';

/// Wrapper que convierte TouristPlace a Place y usa el panel unificado
class PlaceDetailModal extends StatelessWidget {
  final TouristPlace place;

  const PlaceDetailModal({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    // Convertir TouristPlace a Place para usar el panel unificado
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

    // Usar el panel unificado TouristPlacePanel para consistencia
    return TouristPlacePanel(place: convertedPlace);
  }
}