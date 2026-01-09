import '../entities/tourist_place.dart';

abstract class ITouristRepository {
  Future<List<TouristPlace>> getPlaces();
  Future<void> addReview(String placeId, double rating, String comment);
}