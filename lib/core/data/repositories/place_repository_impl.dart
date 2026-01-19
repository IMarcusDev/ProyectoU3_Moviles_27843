import 'package:turismo_app/core/data/datasources/firebase_place_datasource.dart';
import 'package:turismo_app/core/domain/entities/place.dart';
import 'package:turismo_app/core/domain/repositories/place_repository.dart';

class PlaceRepositoryImpl extends PlaceRepository {
  final FirebasePlaceDatasource datasource;

  PlaceRepositoryImpl({
    required this.datasource,
  });

  @override
  Future<Place?> fetchPlace(String id) async {
    return (await datasource.getPlaceById(id))?.toEntity();
  }

  @override
  Future<Place> addPlace(Place p) async {
    return (await datasource.addPlace(p)).toEntity();
  }
}
