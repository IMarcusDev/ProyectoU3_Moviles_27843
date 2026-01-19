import 'package:turismo_app/core/data/datasources/sqlite_place_min_datasource.dart';
import 'package:turismo_app/core/data/models/place_min_model.dart';
import 'package:turismo_app/core/domain/entities/place_min.dart';
import 'package:turismo_app/core/domain/repositories/place_min_repository.dart';

class PlaceMinRepositoryImpl extends PlaceMinRepository {
  final SqlitePlaceMinDatasource datasource = SqlitePlaceMinDatasource();

  @override
  Future<List<PlaceMin>> getAllViewedPlaces() async {
    return (await datasource.getPlaces()).map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<PlaceMin>> getLimitViewedUniquePlaces(int limit) async {
    return (await datasource.getLimitUniquePlaces(limit)).map((e) => e.toEntity()).toList();
  }

  @override
  Future<PlaceMin> addPlace(PlaceMin p) async {
    return (await datasource.savePlace(PlaceMinModel.fromEntity(p))).toEntity();
  }
}
