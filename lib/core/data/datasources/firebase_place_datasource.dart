import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:turismo_app/core/data/models/place_model.dart';
import 'package:turismo_app/core/domain/entities/place.dart';
import 'package:turismo_app/core/utils/logic/vector_utils.dart';

class FirebasePlaceDatasource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  FirebasePlaceDatasource();

  Future<PlaceModel?> getPlaceById(String id) async {
    final doc = await firestore.collection('places').doc(id).get();

    if (!doc.exists) return null;

    final data = doc.data()!;
    data['id'] = doc.id;

    return PlaceModel.fromJson(data);
  }

  Future<PlaceModel> addPlace(Place p) async {
    final doc = firestore.collection('places').doc();

    final model = PlaceModel.fromEntity(p);

    await doc.set(model.toJson());
    return model.copyWith(id: doc.id);
  }

  Future<List<PlaceModel>> getLimitRecomendations(
    String placeId,
    int limit,
  ) async {
    final snapshot = await firestore.collection('places').get();

    final models = snapshot.docs.map((doc) {
      final model = PlaceModel.fromJson(doc.data());
      return model.copyWith(id: doc.id);
    }).toList();

    final reference = models.firstWhere(
      (m) => m.id == placeId,
      orElse: () => throw Exception('Place not found'),
    );

    final refVector = reference.vector.toEntity().toList();

    final top = <({PlaceModel place, double score})>[];

    for (final m in models) {
      if (m.id == placeId) continue;

      final score = VectorUtils.cosineSimilarity(
        m.vector.toEntity().toList(),
        refVector,
      );

      if (top.length < limit) {
        top.add((place: m, score: score));
        top.sort((a, b) => b.score.compareTo(a.score));
        continue;
      }

      if (score <= top.last.score) continue;

      top.removeLast();
      top.add((place: m, score: score));
      top.sort((a, b) => b.score.compareTo(a.score));
    }

    return top.map((e) => e.place).toList();
  }
}
