import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:turismo_app/core/data/models/user_model.dart';
import 'package:turismo_app/core/domain/entities/user.dart';

class FirebaseUserdataSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  FirebaseUserdataSource();

  Future<User> createUser(User user) async {
    final doc = firestore.collection('users').doc();

    final model = UserModel.fromEntity(user);

    await doc.set(model.toJson());
    return model.toEntity();
  }

  Future<User?> fetchUser(int id) async {
    final doc = await firestore.collection('users').doc(id.toString()).get();

    if (!doc.exists) return null;

    return UserModel.fromJson(doc.data()!).toEntity();
  }

  Future<User> updateUser(User user) async {
    final doc =
        firestore.collection('users').doc(user.email);

    await doc.update(UserModel.fromEntity(user).toJson());
    return user;
  }

  Future<User?> loginUser(String email, String password) async {
    final query = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .where('password', isEqualTo: password)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;

    return UserModel.fromJson(query.docs.first.data()).toEntity();
  }
}
