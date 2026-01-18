import 'package:sqflite/sqflite.dart';
import 'package:turismo_app/core/services/sqlite_db.dart';
import 'package:turismo_app/features/menu/data/models/place_min_model.dart';

class SqlitePlaceMinDatasource {
  Future<PlaceMinModel> savePlace(PlaceMinModel place) async {
    final db = await SqliteDb.database;

    await db.insert(
      'places_min',
      place.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return place;
  }

  Future<List<PlaceMinModel>> getPlaces() async {
    final db = await SqliteDb.database;

    final result = await db.query(
      'places_min',
      orderBy: 'last_scanned DESC',
    );

    return result
        .map((json) => PlaceMinModel.fromJson(json))
        .toList();
  }

  Future<void> deletePlace(String id) async {
    final db = await SqliteDb.database;

    await db.delete(
      'places_min',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<PlaceMinModel>> getLimitUniquePlaces(int limit) async {
    final db = await SqliteDb.database;

    final result = await db.rawQuery(
      '''
      SELECT id, name, MAX(last_scanned) AS last_scanned
      FROM places_min
      GROUP BY id
      ORDER BY last_scanned DESC
      LIMIT ?
      ''',
      [limit],
    );

    return result.map((row) => PlaceMinModel.fromJson(row)).toList();
  }
}
