import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:turismo_app/core/data/repositories/user_repository_provider.dart';
import 'package:turismo_app/core/domain/entities/place.dart';
import 'package:turismo_app/core/presentation/widgets/place_rating_widget.dart';
import 'package:turismo_app/core/presentation/widgets/slide_up_widget.dart';
import 'package:turismo_app/core/utils/theme/theme_colors.dart';
import 'package:turismo_app/features/auth/presentation/providers/auth_provider.dart';

class TouristPlacePanel extends ConsumerStatefulWidget {
  final Place place;

  const TouristPlacePanel({
    super.key,
    required this.place,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TouristPlacePanelState();
}

class _TouristPlacePanelState extends ConsumerState<TouristPlacePanel> {
  MapboxMap? _mapboxMap;
  CircleAnnotationManager? _circleAnnotationManager;

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

  Future<void> _onStyleLoaded(StyleLoadedEventData event) async {
    if (_mapboxMap == null) return;

    _circleAnnotationManager ??=
        await _mapboxMap!.annotations.createCircleAnnotationManager();

    await _circleAnnotationManager!.create(
      CircleAnnotationOptions(
        geometry: Point(
          coordinates: Position(
            widget.place.longitude,
            widget.place.latitude,
          ),
        ),
        circleRadius: 8,
        circleColor: ThemeColors.primaryGreen.value,
        circleStrokeWidth: 2,
        circleStrokeColor: Colors.white.value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user!;

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
              onSubmit: (value) {
                final repo = ref.read(userRepositoryProvider);

                repo.ratePlace(user.id!, widget.place.id!, value);
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
                    onStyleLoadedListener: _onStyleLoaded,
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
