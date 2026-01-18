import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:turismo_app/core/domain/entities/place.dart';
import 'package:turismo_app/core/presentation/widgets/place_rating_widget.dart';
import 'package:turismo_app/core/presentation/widgets/slide_up_widget.dart';
import 'package:turismo_app/core/utils/theme/theme_colors.dart';

class TouristPlacePanel extends StatefulWidget {
  final Place place;

  const TouristPlacePanel({
    super.key,
    required this.place,
  });

  @override
  State<TouristPlacePanel> createState() => _TouristPlacePanelState();
}

class _TouristPlacePanelState extends State<TouristPlacePanel> {
  MapboxMap? _mapboxMap;

  Future<void> _onMapCreated(MapboxMap mapboxMap) async {
    _mapboxMap = mapboxMap;

    await _mapboxMap!.location.updateSettings(
      LocationComponentSettings(
        enabled: true,
        pulsingEnabled: true,
        pulsingColor: Colors.blueAccent.value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SlideUpWidget(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            Text(
              widget.place.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: ThemeColors.textPrimary,
              ),
            ),

            // Descripción
            Text(
              widget.place.description,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: ThemeColors.textSecondary,
              ),
            ),

            // Acciones
            PlaceRatingWidget(
              onRatingChanged: (rating) {
                print('Calificación: $rating');
                // enviar a backend / guardar localmente
              },
            ),

            Text(
              'Ubicación',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: ThemeColors.textPrimary,
              ),
            ),
            SizedBox(
              height: 160,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ThemeColors.primaryGreen.withValues(alpha: 0.3),
                    ),
                  ),
                  child: MapWidget(
                    styleUri: MapboxStyles.OUTDOORS,
                    gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
                    cameraOptions: CameraOptions(
                      center: Point(
                        coordinates: Position(
                          widget.place.longitude,
                          widget.place.latitude,
                        ),
                      ),
                      zoom: 14.0,
                    ),
                    onMapCreated: _onMapCreated,
                  )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
