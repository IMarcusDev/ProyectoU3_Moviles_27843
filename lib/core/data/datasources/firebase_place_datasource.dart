import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:turismo_app/core/data/models/place_model.dart';

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
}
