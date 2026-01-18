import 'package:turismo_app/core/domain/entities/preferences.dart';

class Place {
  final String id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final Preferences vector;

  const Place({
    required this.id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.vector,
  });
}
