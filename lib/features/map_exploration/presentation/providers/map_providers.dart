import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/utils/logic/recommendation_engine.dart';
import '../../../../core/services/location_service.dart';
import '../../data/repositories/tourist_repository_impl.dart';
import '../../domain/entities/tourist_place.dart';
import '../../domain/repositories/i_tourist_repository.dart';
import '../../domain/services/route_service.dart';

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final touristRepositoryProvider = Provider<ITouristRepository>((ref) {
  return TouristRepositoryImpl(ref.watch(firestoreProvider));
});

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

final allPlacesProvider = FutureProvider<List<TouristPlace>>((ref) async {
  final repository = ref.watch(touristRepositoryProvider);
  return repository.getPlaces();
});

final userLocationProvider = FutureProvider<Position>((ref) async {
  final service = ref.watch(locationServiceProvider);
  return service.getCurrentPosition();
});

final selectedCategoryProvider = StateProvider<String>((ref) => "Todos");

final searchQueryProvider = StateProvider<String>((ref) => "");

final maxDistanceProvider = StateProvider<double?>((ref) => null); // null = sin filtro

final minRatingProvider = StateProvider<double?>((ref) => null); // null = sin filtro

final userInterestsProvider = StateProvider<Map<String, double>>((ref) {
  return {};
});

// Provider que cuenta lugares por categoría
final categoryCountsProvider = Provider<AsyncValue<Map<String, int>>>((ref) {
  final allPlacesAsync = ref.watch(allPlacesProvider);

  return allPlacesAsync.whenData((places) {
    final counts = <String, int>{'Todos': places.length};

    for (final place in places) {
      counts[place.category] = (counts[place.category] ?? 0) + 1;
    }

    return counts;
  });
});

final filteredPlacesProvider = Provider<AsyncValue<List<TouristPlace>>>((ref) {
  final allPlacesAsync = ref.watch(allPlacesProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final searchQuery = ref.watch(searchQueryProvider);
  final maxDistance = ref.watch(maxDistanceProvider);
  final minRating = ref.watch(minRatingProvider);
  final userLocationAsync = ref.watch(userLocationProvider);
  final userInterests = ref.watch(userInterestsProvider);
  final recommendationEngine = RecommendationEngine();

  return allPlacesAsync.whenData((places) {
    var filtered = places;

    // Filtro por categoría
    if (selectedCategory != "Todos") {
      filtered = filtered.where((p) => p.category == selectedCategory).toList();
    }

    // Filtro por búsqueda (nombre o descripción)
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      filtered = filtered.where((p) =>
        p.name.toLowerCase().contains(query) ||
        p.description.toLowerCase().contains(query)
      ).toList();
    }

    // Filtro por calificación
    if (minRating != null) {
      filtered = filtered.where((p) => p.rating >= minRating).toList();
    }

    // Filtro por distancia (requiere ubicación del usuario)
    if (maxDistance != null) {
      userLocationAsync.whenData((userPos) {
        filtered = filtered.where((place) {
          final distance = Geolocator.distanceBetween(
            userPos.latitude,
            userPos.longitude,
            place.latitude,
            place.longitude,
          ) / 1000; // Convertir a kilómetros
          return distance <= maxDistance;
        }).toList();
      });
    }

    return recommendationEngine.recommend(
      places: filtered,
      userInterests: userInterests
    );
  });
});

// Provider del servicio de rutas
final routeServiceProvider = Provider<RouteService>((ref) {
  return RouteService();
});

// Provider de la ruta generada (null cuando no hay ruta activa)
final generatedRouteProvider = StateProvider<List<TouristPlace>?>((ref) => null);