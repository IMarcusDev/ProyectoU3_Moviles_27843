import 'package:turismo_app/core/data/models/preferences_model.dart';
import 'package:turismo_app/core/domain/entities/user.dart';

class UserModel {
  final int id;
  final String name;
  final String surname;
  final String email;
  final PreferencesModel vector;

  UserModel({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    required this.vector,
  });

  factory UserModel.create(
    String name,
    String surname,
    String email,
  ) {
    return UserModel(
      id: User.getEmptyId(),
      name: name,
      surname: surname,
      email: email,
      vector: PreferencesModel.empty(),
    );
  }

  UserModel copyWith({
    String? name,
    String? surname,
    String? email,
    PreferencesModel? vector,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      email: email ?? this.email,
      vector: vector ?? this.vector,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      surname: json['surname'] as String,
      email: json['email'] as String,
      vector: PreferencesModel.fromJson(
        json['vector'] as Map<String, dynamic>,
      ),
    );
  }

  factory UserModel.fromEntity(User u) {
    return UserModel(
      id: u.id,
      name: u.name,
      surname: u.surname,
      email: u.email,
      vector: PreferencesModel.fromEntity(u.vector),
    );
  }

  User toEntity() {
    return User(
      id: id,
      name: name,
      surname: surname,
      email: email,
      vector: vector.toEntity(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'email': email,
      'vector': vector.toJson(),
    };
  }
}
