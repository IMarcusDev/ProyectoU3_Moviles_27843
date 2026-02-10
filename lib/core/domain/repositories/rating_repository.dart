import '../entities/rating.dart';

abstract class RatingRepository {
  /// Crear o actualizar una calificación
  Future<Rating> saveRating(Rating rating);

  /// Obtener todas las calificaciones de un lugar
  Future<List<Rating>> getRatingsForPlace(String placeId);

  /// Obtener la calificación de un usuario para un lugar específico
  Future<Rating?> getUserRatingForPlace(String userId, String placeId);

  /// Calcular el promedio de calificaciones de un lugar
  Future<double> getAverageRating(String placeId);

  /// Eliminar una calificación
  Future<bool> deleteRating(String ratingId);
}
