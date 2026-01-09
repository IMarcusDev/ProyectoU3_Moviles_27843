import '../../domain/entities/tourist_place.dart';

class PlaceModel extends TouristPlace {
  const PlaceModel({
    required super.id,
    required super.name,
    required super.description,
    required super.latitude,
    required super.longitude,
    required super.imageUrls,
    required super.rating,
    required super.ratingCount,
    required super.category,
    required super.interestVector,
  });

  factory PlaceModel.fromFirestore(Map<String, dynamic> json, String id) {
    return PlaceModel(
      id: id,
      name: json['name'] ?? 'Sin nombre',
      description: json['description'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      ratingCount: (json['ratingCount'] as num?)?.toInt() ?? 0,
      category: json['category'] ?? 'General',
      interestVector: Map<String, double>.from(
        (json['interestVector'] ?? {}).map(
          (key, value) => MapEntry(key, (value as num).toDouble()),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'imageUrls': imageUrls,
      'rating': rating,
      'ratingCount': ratingCount,
      'category': category,
      'interestVector': interestVector,
    };
  }
}