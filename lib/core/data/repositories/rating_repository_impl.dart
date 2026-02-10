import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/rating.dart';
import '../../domain/repositories/rating_repository.dart';
import '../models/rating_model.dart';

class RatingRepositoryImpl implements RatingRepository {
  final FirebaseFirestore _firestore;

  RatingRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<Rating> saveRating(Rating rating) async {
    try {
      final model = RatingModel.fromEntity(rating);
      final collection = _firestore.collection('ratings');

      // Si tiene ID, actualizar; si no, crear nuevo
      if (rating.id != null) {
        await collection.doc(rating.id).set(model.toJson(), SetOptions(merge: true));
        return rating;
      } else {
        final docRef = await collection.add(model.toJson());
        await docRef.update({'id': docRef.id});
        return rating.copyWith(id: docRef.id);
      }
    } catch (e) {
      throw Exception('Error guardando calificación: $e');
    }
  }

  @override
  Future<List<Rating>> getRatingsForPlace(String placeId) async {
    try {
      final querySnapshot = await _firestore
          .collection('ratings')
          .where('placeId', isEqualTo: placeId)
          .get();

      final ratings = querySnapshot.docs
          .map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return RatingModel.fromJson(data).toEntity();
          })
          .toList();

      // Ordenar en el cliente por fecha (más reciente primero)
      ratings.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return ratings;
    } catch (e) {
      throw Exception('Error obteniendo calificaciones: $e');
    }
  }

  @override
  Future<Rating?> getUserRatingForPlace(String userId, String placeId) async {
    try {
      final querySnapshot = await _firestore
          .collection('ratings')
          .where('userId', isEqualTo: userId)
          .where('placeId', isEqualTo: placeId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) return null;

      final doc = querySnapshot.docs.first;
      final data = doc.data();
      data['id'] = doc.id;
      return RatingModel.fromJson(data).toEntity();
    } catch (e) {
      throw Exception('Error obteniendo calificación del usuario: $e');
    }
  }

  @override
  Future<double> getAverageRating(String placeId) async {
    try {
      final ratings = await getRatingsForPlace(placeId);

      if (ratings.isEmpty) return 0.0;

      final sum = ratings.fold<int>(0, (prev, rating) => prev + rating.stars);
      return sum / ratings.length;
    } catch (e) {
      return 0.0;
    }
  }

  @override
  Future<bool> deleteRating(String ratingId) async {
    try {
      await _firestore.collection('ratings').doc(ratingId).delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
