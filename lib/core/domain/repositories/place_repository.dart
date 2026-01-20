import 'package:turismo_app/core/domain/entities/place.dart';

abstract class PlaceRepository {
  Future<Place?> fetchPlace(String id);
  Future<Place> addPlace(Place p);
  Future<List<Place>> fetchLimitRecomendations(String id, int limit);
}
