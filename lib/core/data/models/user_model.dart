import 'package:turismo_app/core/data/models/preferences_model.dart';
import 'package:turismo_app/core/domain/entities/user.dart';

class UserModel {
  final String name;
  final String surname;
  final String email;
  final PreferencesModel vector;

  UserModel({
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
      name: name ?? this.name,
      surname: surname ?? this.surname,
      email: email ?? this.email,
      vector: vector ?? this.vector,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
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
      name: u.name,
      surname: u.surname,
      email: u.email,
      vector: PreferencesModel.fromEntity(u.vector),
    );
  }

  User toEntity() {
    return User(
      name: name,
      surname: surname,
      email: email,
      vector: vector.toEntity(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'surname': surname,
      'email': email,
      'vector': vector.toJson(),
    };
  }
}
