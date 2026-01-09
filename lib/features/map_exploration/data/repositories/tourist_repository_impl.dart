import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/tourist_place.dart';
import '../../domain/repositories/i_tourist_repository.dart';
import '../models/place_model.dart';

class TouristRepositoryImpl implements ITouristRepository {
  final FirebaseFirestore _firestore;

  TouristRepositoryImpl(this._firestore);

  @override
  Future<List<TouristPlace>> getPlaces() async {
    try {
      final snapshot = await _firestore.collection('places').get();
      return snapshot.docs
          .map((doc) => PlaceModel.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception("Error al cargar lugares: $e");
    }
  }

  @override
  Future<void> addReview(String placeId, double rating, String comment) async {
    final placeRef = _firestore.collection('places').doc(placeId);
    final reviewRef = placeRef.collection('reviews').doc();

    try {
      await _firestore.runTransaction((transaction) async {
        final placeSnapshot = await transaction.get(placeRef);
        
        if (!placeSnapshot.exists) {
          throw Exception("El lugar no existe");
        }

        final data = placeSnapshot.data()!;
        final double currentRating = (data['rating'] as num?)?.toDouble() ?? 0.0;
        final int currentCount = (data['ratingCount'] as num?)?.toInt() ?? 0;

        final double newRating = ((currentRating * currentCount) + rating) / (currentCount + 1);

        transaction.set(reviewRef, {
          'rating': rating,
          'comment': comment,
          'timestamp': FieldValue.serverTimestamp(),
        });

        transaction.update(placeRef, {
          'rating': newRating,
          'ratingCount': currentCount + 1,
        });
      });
    } catch (e) {
      throw Exception("Error al guardar reseña: $e");
    }
  }
}