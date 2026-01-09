import '../../features/map_exploration/domain/entities/tourist_place.dart';

class RecommendationEngine {
  List<TouristPlace> recommend({
    required List<TouristPlace> places,
    required Map<String, double> userInterests,
  }) {
    if (userInterests.isEmpty) {
      final sorted = List<TouristPlace>.from(places);
      sorted.sort((a, b) => b.rating.compareTo(a.rating));
      return sorted;
    }
    List<MapEntry<TouristPlace, double>> scoredPlaces = [];

    for (var place in places) {
      double score = 0.0;

      userInterests.forEach((tag, userWeight) {
        double placeWeight = place.interestVector[tag] ?? 0.0;
        score += (userWeight * placeWeight);
      });
      double qualityBonus = (place.rating / 5.0) * 0.5; 
      
      scoredPlaces.add(MapEntry(place, score + qualityBonus));
    }

    scoredPlaces.sort((a, b) => b.value.compareTo(a.value));

    return scoredPlaces.map((e) => e.key).toList();
  }
}