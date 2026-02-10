import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:turismo_app/core/data/repositories/rating_repository_provider.dart';
import 'package:turismo_app/core/domain/entities/place.dart';
import 'package:turismo_app/core/domain/entities/rating.dart' as rating_entity;
import 'package:turismo_app/core/presentation/widgets/place_rating_widget.dart';
import 'package:turismo_app/core/presentation/widgets/comments_section.dart';
import 'package:turismo_app/core/presentation/widgets/recomendation_slidebar.dart';
import 'package:turismo_app/core/presentation/widgets/slide_up_widget.dart';
import 'package:turismo_app/core/utils/theme/theme_colors.dart';
import 'package:turismo_app/core/presentation/providers/auth_provider.dart';
import 'package:turismo_app/core/utils/ui/app_snackbar.dart';

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
  late Future<rating_entity.Rating?> _existingRatingFuture;

  @override
  void initState() {
    super.initState();
    // Cachear el Future para evitar recargas cuando aparece el teclado
    _loadExistingRating();
  }

  void _loadExistingRating() {
    final user = ref.read(authProvider).user!;
    final ratingRepo = ref.read(ratingRepositoryProvider);
    _existingRatingFuture = ratingRepo.getUserRatingForPlace(user.id!, widget.place.id!);
  }

  Future<void> _onMapCreated(MapboxMap mapboxMap) async {
    _mapboxMap = mapboxMap;

    await _mapboxMap!.location.updateSettings(
      LocationComponentSettings(
        enabled: true,
        pulsingEnabled: true,
        pulsingColor: Colors.blueAccent.toARGB32(),
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
        circleColor: ThemeColors.primaryGreen.toARGB32(),
        circleStrokeWidth: 2,
        circleStrokeColor: Colors.white.toARGB32(),
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

            // Rating (con FutureBuilder para cargar calificación existente)
            FutureBuilder<rating_entity.Rating?>(
              future: _existingRatingFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: ThemeColors.primaryGreen,
                      ),
                    ),
                  );
                }

                final existingRating = snapshot.data;

                return PlaceRatingWidget(
                  existingRating: existingRating,
                  onSubmit: (stars, comment) async {
                    final ratingRepo = ref.read(ratingRepositoryProvider);

                    // Crear o actualizar Rating
                    final newRating = rating_entity.Rating(
                      id: existingRating?.id, // Mantener ID si existe para actualizar
                      userId: user.id!,
                      userName: user.name,
                      placeId: widget.place.id!,
                      stars: stars,
                      comment: comment,
                      createdAt: existingRating?.createdAt ?? DateTime.now(),
                    );

                    try {
                      await ratingRepo.saveRating(newRating);

                      // Mostrar confirmación
                      if (!mounted) return;
                      AppSnackbar.showSuccess(
                        context,
                        existingRating != null
                            ? '¡Calificación actualizada!'
                            : (comment != null && comment.isNotEmpty
                                ? '¡Calificación y comentario enviados!'
                                : '¡Calificación de $stars ⭐ enviada!'),
                      );

                      // Recargar la calificación y comentarios
                      setState(() {
                        _loadExistingRating();
                      });
                    } catch (e) {
                      if (!mounted) return;
                      AppSnackbar.showError(
                        context,
                        'Error al guardar calificación',
                      );
                    }
                  },
                );
              },
            ),

            // Comentarios y Calificaciones
            const Text(
              'Comentarios y Calificaciones',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: ThemeColors.textPrimary,
              ),
            ),
            CommentsSection(
              placeId: widget.place.id!,
            ),

            // Recomendaciones
            const Text(
              'Lugares Similares',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: ThemeColors.textPrimary,
              ),
            ),
            RecomendationSlidebar(
              placeReferenceId: widget.place.id!,
            ),

            // Ubicación
            const Text(
              'Ubicación',
              style: TextStyle(
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
