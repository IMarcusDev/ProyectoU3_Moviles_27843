import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart' as geo;

import '../../domain/entities/tourist_place.dart';
import '../providers/map_providers.dart';
import '../widgets/place_detail_modal.dart';
import '../widgets/category_chip.dart';
import '../widgets/map_filters_sheet.dart';
import '../widgets/route_sheet.dart';
import 'package:turismo_app/core/utils/theme/theme_colors.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  mapbox.MapboxMap? _mapboxMap;
  mapbox.PointAnnotationManager? _pointAnnotationManager;
  mapbox.CircleAnnotationManager? _circleAnnotationManager;
  mapbox.PolylineAnnotationManager? _polylineAnnotationManager;
  final TextEditingController _searchController = TextEditingController();

  // Mapa de categorías con sus iconos
  final Map<String, IconData> _categories = {
    "Todos": Icons.explore,
    "Gastronomía": Icons.restaurant,
    "Cultura": Icons.museum,
    "Naturaleza": Icons.park,
    "Hoteles": Icons.hotel,
    "Aventura": Icons.hiking,
    "Compras": Icons.shopping_bag,
  };

  Future<void> _onMapCreated(mapbox.MapboxMap mapboxMap) async {
    _mapboxMap = mapboxMap;

    debugPrint('🗺️ Mapa creado, inicializando managers...');

    // Crear managers de anotaciones
    _pointAnnotationManager =
        await mapboxMap.annotations.createPointAnnotationManager();

    _circleAnnotationManager =
        await mapboxMap.annotations.createCircleAnnotationManager();

    _polylineAnnotationManager =
        await mapboxMap.annotations.createPolylineAnnotationManager();

    debugPrint('✅ Managers creados correctamente');

    // Configurar clicks en círculos (usando el método correcto)
    _circleAnnotationManager!.addOnCircleAnnotationClickListener(
      _CircleClickListener(this, ref),
    );

    // Configurar ubicación del usuario
    await _mapboxMap!.location.updateSettings(
      mapbox.LocationComponentSettings(
        enabled: true,
        pulsingEnabled: true,
        pulsingColor: Colors.blueAccent.toARGB32(),
      ),
    );

    debugPrint('📍 Ubicación del usuario configurada');
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

    // Escuchar cambios en la ruta generada
    ref.listen<List<TouristPlace>?>(
      generatedRouteProvider,
      (previous, next) {
        if (next != null) {
          userLocationAsync.whenData((userLocation) {
            _drawRoutePolyline(next, userLocation);
          });
        } else {
          _clearRoutePolyline();
        }
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

          // ─────────── Barra de Búsqueda ───────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 12,
            right: 12,
            child: Row(
              children: [
                // Campo de búsqueda
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {}); // Rebuild para mostrar/ocultar botón clear
                        ref.read(searchQueryProvider.notifier).state = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Buscar lugares...',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: ThemeColors.primaryGreen,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 20),
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                  });
                                  ref.read(searchQueryProvider.notifier).state = '';
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Botón de filtros
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: ThemeColors.primaryGreen,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: ThemeColors.primaryGreen.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.tune, color: Colors.white),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        builder: (_) => const MapFiltersSheet(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // ─────────── Categorías ───────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 68,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 50,
              child: ref.watch(categoryCountsProvider).when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
                data: (counts) {
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: _categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final entry = _categories.entries.elementAt(index);
                      final categoryName = entry.key;
                      final categoryIcon = entry.value;
                      final isSelected = selectedCategory == categoryName;
                      final count = counts[categoryName];

                      return CategoryChip(
                        label: categoryName,
                        icon: categoryIcon,
                        isSelected: isSelected,
                        count: count,
                        onTap: () {
                          ref.read(selectedCategoryProvider.notifier).state = categoryName;
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),

          // ─────────── Contador de Lugares y Botón Ruta ───────────
          Positioned(
            bottom: 30,
            left: 20,
            child: ref.watch(filteredPlacesProvider).when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (places) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Contador de lugares
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.place,
                          color: ThemeColors.primaryGreen,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${places.length} lugar${places.length != 1 ? 'es' : ''}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: ThemeColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Botón generar ruta (solo si hay 2+ lugares)
                  if (places.length >= 2) ...[
                    const SizedBox(height: 10),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _generateRoute(places),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: ThemeColors.primaryGreen,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: ThemeColors.primaryGreen.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.route,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Generar Ruta',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // ─────────── Botón Volver ───────────
          Positioned(
            bottom: 30,
            right: 20,
            child: FloatingActionButton.extended(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              label: const Text(
                "Volver",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: ThemeColors.primaryGreen,
              elevation: 4,
            ),
          ),
        ],
      ),
    );
  }

  void _generateRoute(List<TouristPlace> places) async {
    final userLocationAsync = ref.read(userLocationProvider);

    userLocationAsync.when(
      data: (userLocation) {
        // Generar ruta usando el servicio
        final routeService = ref.read(routeServiceProvider);
        final route = routeService.generateRoute(
          places: places,
          userLocation: userLocation,
        );

        // Guardar ruta en el provider
        ref.read(generatedRouteProvider.notifier).state = route;

        debugPrint('🗺️ Ruta generada con ${route.length} lugares');

        // Mostrar sheet con la ruta
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.5,
            maxChildSize: 0.9,
            builder: (_, controller) => RouteSheet(
              route: route,
              userLocation: userLocation,
            ),
          ),
        );
      },
      loading: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Obteniendo ubicación...')),
        );
      },
      error: (err, _) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $err')),
        );
      },
    );
  }

  Future<void> _drawRoutePolyline(
    List<TouristPlace> route,
    geo.Position userLocation,
  ) async {
    if (_polylineAnnotationManager == null) {
      debugPrint('⚠️ PolylineAnnotationManager no inicializado');
      return;
    }

    try {
      // Limpiar polylines anteriores
      await _polylineAnnotationManager!.deleteAll();

      // Crear lista de coordenadas (desde usuario -> lugar1 -> lugar2 -> ...)
      final coordinates = <mapbox.Position>[];

      // Agregar ubicación del usuario como punto inicial
      coordinates.add(mapbox.Position(
        userLocation.longitude,
        userLocation.latitude,
      ));

      // Agregar cada lugar de la ruta
      for (final place in route) {
        coordinates.add(mapbox.Position(
          place.longitude,
          place.latitude,
        ));
      }

      // Crear la polyline con las coordenadas
      final lineString = mapbox.LineString(coordinates: coordinates);

      final polylineOptions = mapbox.PolylineAnnotationOptions(
        geometry: lineString,
        lineColor: ThemeColors.primaryGreen.toARGB32(),
        lineWidth: 4.0,
        lineOpacity: 0.8,
      );

      await _polylineAnnotationManager!.create(polylineOptions);

      debugPrint('✅ Polyline de ruta dibujada con ${coordinates.length} puntos');
    } catch (e) {
      debugPrint('❌ Error dibujando polyline: $e');
    }
  }

  Future<void> _clearRoutePolyline() async {
    if (_polylineAnnotationManager == null) return;

    try {
      await _polylineAnnotationManager!.deleteAll();
      debugPrint('🗑️ Polyline de ruta eliminada');
    } catch (e) {
      debugPrint('❌ Error limpiando polyline: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _updateMarkers(List<TouristPlace> places) async {
    if (_circleAnnotationManager == null || _pointAnnotationManager == null) {
      debugPrint('⚠️ Managers no inicializados aún');
      return;
    }

    try {
      // Limpiar marcadores anteriores
      await _circleAnnotationManager!.deleteAll();
      await _pointAnnotationManager!.deleteAll();

      debugPrint('📍 Actualizando ${places.length} marcadores en el mapa');

      // Crear nuevos marcadores para cada lugar
      for (final place in places) {
        final point = mapbox.Point(
          coordinates: mapbox.Position(
            place.longitude,
            place.latitude,
          ),
        );

        // Crear círculo visible (el marcador principal)
        final circleOptions = mapbox.CircleAnnotationOptions(
          geometry: point,
          circleRadius: 10.0,
          circleColor: ThemeColors.primaryGreen.toARGB32(),
          circleStrokeWidth: 3.0,
          circleStrokeColor: Colors.white.toARGB32(),
        );
        await _circleAnnotationManager!.create(circleOptions);

        // Crear etiqueta de texto
        final textOptions = mapbox.PointAnnotationOptions(
          geometry: point,
          textField: place.name,
          textSize: 11.0,
          textColor: Colors.white.toARGB32(),
          textHaloColor: ThemeColors.primaryGreen.toARGB32(),
          textHaloWidth: 2.0,
          textOffset: [0, -1.8],
        );
        await _pointAnnotationManager!.create(textOptions);
      }

      debugPrint('✅ ${places.length} marcadores creados correctamente');
    } catch (e) {
      debugPrint('❌ Error actualizando marcadores: $e');
    }
  }
}

class _CircleClickListener extends mapbox.OnCircleAnnotationClickListener {
  final _MapPageState state;
  final WidgetRef ref;

  _CircleClickListener(this.state, this.ref);

  @override
  bool onCircleAnnotationClick(mapbox.CircleAnnotation annotation) {
    final places = ref.read(filteredPlacesProvider).value ?? [];

    try {
      // Buscar el lugar por coordenadas (con tolerancia pequeña)
      final place = places.firstWhere(
        (p) {
          final lat = annotation.geometry.coordinates.lat;
          final lng = annotation.geometry.coordinates.lng;
          final distance = (p.latitude - lat).abs() + (p.longitude - lng).abs();
          return distance < 0.0001; // Tolerancia de ~10 metros
        },
      );

      debugPrint('📍 Click en marcador: ${place.name}');

      showModalBottomSheet(
        context: state.context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => PlaceDetailModal(place: place),
      );
    } catch (e) {
      debugPrint('❌ Lugar no encontrado en coordenadas: ${annotation.geometry.coordinates}');
    }

    return true;
  }
}
