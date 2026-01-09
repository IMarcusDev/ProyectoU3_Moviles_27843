import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart' as geo;

import '../../domain/entities/tourist_place.dart';
import '../providers/map_providers.dart';
import '../widgets/place_detail_modal.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  mapbox.MapboxMap? _mapboxMap;
  mapbox.PointAnnotationManager? _pointAnnotationManager;

  final List<String> _categories = [
    "Todos",
    "Gastronomía",
    "Cultura",
    "Naturaleza",
    "Hoteles"
  ];

  Future<void> _onMapCreated(mapbox.MapboxMap mapboxMap) async {
    _mapboxMap = mapboxMap;

    _pointAnnotationManager =
        await mapboxMap.annotations.createPointAnnotationManager();

    _pointAnnotationManager?.addOnPointAnnotationClickListener(
      _MarkerClickListener(this, ref),
    );

    await mapboxMap.location.updateSettings(
      mapbox.LocationComponentSettings(
        enabled: true,
        pulsingEnabled: true,
        pulsingColor: Colors.blueAccent.value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userLocationAsync = ref.watch(userLocationProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    ref.listen<AsyncValue<List<TouristPlace>>>(
      filteredPlacesProvider,
      (previous, next) {
        next.whenData(_updateMarkers);
      },
    );

    return Scaffold(
      body: Stack(
        children: [
          userLocationAsync.when(
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (err, st) =>
                Center(child: Text("Error GPS: $err")),
            data: (geo.Position position) {
              return mapbox.MapWidget(
                styleUri: mapbox.MapboxStyles.OUTDOORS,
                cameraOptions: mapbox.CameraOptions(
                  center: mapbox.Point(
                    coordinates: mapbox.Position(
                      position.longitude,
                      position.latitude,
                    ),
                  ),
                  zoom: 13.0,
                ),
                onMapCreated: _onMapCreated,
              );
            },
          ),

          // ─────────── Categorías ───────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = selectedCategory == category;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (_) {
                        ref
                            .read(
                                selectedCategoryProvider.notifier)
                            .state = category;
                      },
                      backgroundColor: Colors.white,
                      selectedColor: Colors.indigoAccent,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : Colors.black87,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // ─────────── Botón AR ───────────
          Positioned(
            bottom: 30,
            right: 20,
            child: FloatingActionButton.extended(
              onPressed: () {
                try {
                  context.push('/ar');
                } catch (_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text("Error al navegar a AR"),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.view_in_ar,
                  color: Colors.white),
              label: const Text(
                "Modo AR",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.indigo,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateMarkers(
      List<TouristPlace> places) async {
    if (_pointAnnotationManager == null) return;

    await _pointAnnotationManager!.deleteAll();

    for (final place in places) {
      final options = mapbox.PointAnnotationOptions(
        geometry: mapbox.Point(
          coordinates: mapbox.Position(
            place.longitude,
            place.latitude,
          ),
        ),
        textField: place.name,
        textOffset: [0, -2.0],
        iconSize: 1.0,
      );

      await _pointAnnotationManager!.create(options);
    }
  }
}

class _MarkerClickListener
    extends mapbox.OnPointAnnotationClickListener {
  final _MapPageState state;
  final WidgetRef ref;

  _MarkerClickListener(this.state, this.ref);

  @override
  bool onPointAnnotationClick(
      mapbox.PointAnnotation annotation) {
    final places =
        ref.read(filteredPlacesProvider).value ?? [];

    try {
      final place = places.firstWhere(
        (p) => p.name == annotation.textField,
      );

      showModalBottomSheet(
        context: state.context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => PlaceDetailModal(place: place),
      );
    } catch (_) {
      debugPrint(
          "Lugar no encontrado: ${annotation.textField}");
    }

    return true;
  }
}
