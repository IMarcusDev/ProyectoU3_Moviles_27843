import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:turismo_app/core/data/models/place_model.dart';
import 'package:turismo_app/core/domain/entities/place.dart';

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
}
