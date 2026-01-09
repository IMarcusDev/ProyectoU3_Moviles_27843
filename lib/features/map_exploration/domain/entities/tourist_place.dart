import 'package:equatable/equatable.dart';

class TouristPlace extends Equatable {
  final String id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final List<String> imageUrls;
  final double rating;
  final int ratingCount; // Importante para calcular promedios
  final String category;
  final Map<String, double> interestVector; // Para el algoritmo KNN

  const TouristPlace({
    required this.id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.imageUrls,
    required this.rating,
    required this.ratingCount,
    required this.category,
    required this.interestVector,
  });

  @override
  List<Object?> get props => [id, name, rating, ratingCount];
}