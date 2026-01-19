import 'package:turismo_app/core/domain/entities/place_min.dart';

class PlaceMinModel {
  final String id;
  final String name;
  final DateTime lastScanned;

  PlaceMinModel({
    required this.id,
    required this.name,
    required this.lastScanned,
  });

  PlaceMinModel copyWith({
    String? id,
    String? name,
    DateTime? lastScanned,
  }) {
    return PlaceMinModel(
      id: id ?? this.id,
      name: name ?? this.name,
      lastScanned: lastScanned ?? this.lastScanned,
    );
  }

  factory PlaceMinModel.fromEntity(PlaceMin place) {
    return PlaceMinModel(
      id: place.id,
      name: place.name,
      lastScanned: place.lastScanned,
    );
  }

  PlaceMin toEntity() {
    return PlaceMin(
      id: id,
      name: name,
      lastScanned: lastScanned,
    );
  }

  factory PlaceMinModel.fromJson(Map<String, dynamic> json) {
    return PlaceMinModel(
      id: json['id'] as String,
      name: json['name'] as String,
      lastScanned: DateTime.fromMillisecondsSinceEpoch(
        json['last_scanned'] as int,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'last_scanned': lastScanned.millisecondsSinceEpoch,
    };
  }
}
