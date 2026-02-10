import 'package:geolocator/geolocator.dart';
import '../entities/tourist_place.dart';

/// Servicio para generar rutas turísticas optimizadas por proximidad
class RouteService {
  /// Genera una ruta ordenada usando algoritmo greedy (vecino más cercano)
  /// Comienza desde la ubicación del usuario y visita los lugares en orden de proximidad
  List<TouristPlace> generateRoute({
    required List<TouristPlace> places,
    required Position userLocation,
  }) {
    if (places.isEmpty) return [];
    if (places.length == 1) return places;

    final route = <TouristPlace>[];
    final remainingPlaces = List<TouristPlace>.from(places);

    double currentLat = userLocation.latitude;
    double currentLon = userLocation.longitude;

    // Algoritmo greedy: siempre elegir el lugar más cercano
    while (remainingPlaces.isNotEmpty) {
      TouristPlace? nearestPlace;
      double minDistance = double.infinity;

      for (final place in remainingPlaces) {
        final distance = Geolocator.distanceBetween(
          currentLat,
          currentLon,
          place.latitude,
          place.longitude,
        );

        if (distance < minDistance) {
          minDistance = distance;
          nearestPlace = place;
        }
      }

      if (nearestPlace != null) {
        route.add(nearestPlace);
        remainingPlaces.remove(nearestPlace);
        currentLat = nearestPlace.latitude;
        currentLon = nearestPlace.longitude;
      }
    }

    return route;
  }

  /// Calcula la distancia total de la ruta en kilómetros
  double calculateTotalDistance({
    required List<TouristPlace> route,
    required Position userLocation,
  }) {
    if (route.isEmpty) return 0.0;

    double totalDistance = 0.0;
    double currentLat = userLocation.latitude;
    double currentLon = userLocation.longitude;

    for (final place in route) {
      totalDistance += Geolocator.distanceBetween(
        currentLat,
        currentLon,
        place.latitude,
        place.longitude,
      );
      currentLat = place.latitude;
      currentLon = place.longitude;
    }

    return totalDistance / 1000; // Convertir a kilómetros
  }

  /// Estima el tiempo total de la ruta asumiendo velocidad promedio de 40 km/h
  Duration estimateRouteDuration({
    required List<TouristPlace> route,
    required Position userLocation,
    int minutesPerPlace = 30, // Tiempo estimado por visita
  }) {
    final distance = calculateTotalDistance(
      route: route,
      userLocation: userLocation,
    );

    final travelMinutes = (distance / 40 * 60).round(); // 40 km/h promedio
    final visitMinutes = route.length * minutesPerPlace;

    return Duration(minutes: travelMinutes + visitMinutes);
  }
}
