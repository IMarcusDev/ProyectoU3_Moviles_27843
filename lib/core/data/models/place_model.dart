import 'package:turismo_app/core/data/models/preferences_model.dart';
import 'package:turismo_app/core/domain/entities/place.dart';

class PlaceModel {
  final String? id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final PreferencesModel vector;

  PlaceModel({
    this.id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.vector,
  });

  PlaceModel copyWith({
    String? name,
    String? description,
    double? latitude,
    double? longitude,
    PreferencesModel? vector,
  }) {
    return PlaceModel(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      vector: vector ?? this.vector,
    );
  }

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      id: json['id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      vector: PreferencesModel.fromJson(
        json['interestVector'] as Map<String, dynamic>,
      ),
    );
  }

  factory PlaceModel.fromEntity(Place place) {
    return PlaceModel(
      id: place.id,
      name: place.name,
      description: place.description,
      latitude: place.latitude,
      longitude: place.longitude,
      vector: PreferencesModel.fromEntity(place.vector),
    );
  }

  Place toEntity() {
    return Place(
      id: id ?? '',
      name: name,
      description: description,
      latitude: latitude,
      longitude: longitude,
      vector: vector.toEntity(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'interestVector': vector.toJson(),
    };
  }
}
