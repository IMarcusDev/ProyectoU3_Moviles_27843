import 'package:turismo_app/core/domain/entities/place_min.dart';

abstract class PlaceMinRepository {
  Future<List<PlaceMin>> getAllViewedPlaces();
  Future<List<PlaceMin>> getLimitViewedUniquePlaces(int limit);
  Future<PlaceMin> addPlace(PlaceMin p);
  Future<void> removeAllPlaces();
}
