import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/utils/logic/recommendation_engine.dart';
import '../../../../core/services/location_service.dart';
import '../../data/repositories/tourist_repository_impl.dart';
import '../../domain/entities/tourist_place.dart';
import '../../domain/repositories/i_tourist_repository.dart';

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

final userInterestsProvider = StateProvider<Map<String, double>>((ref) {
  return {}; 
});

final filteredPlacesProvider = Provider<AsyncValue<List<TouristPlace>>>((ref) {
  
  final allPlacesAsync = ref.watch(allPlacesProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final userInterests = ref.watch(userInterestsProvider);
  final recommendationEngine = RecommendationEngine();

  return allPlacesAsync.whenData((places) {
    List<TouristPlace> step1Filtered;
    if (selectedCategory == "Todos") {
      step1Filtered = places;
    } else {
      step1Filtered = places.where((p) => p.category == selectedCategory).toList();
    }

    return recommendationEngine.recommend(
      places: step1Filtered,
      userInterests: userInterests
    );
  });
});