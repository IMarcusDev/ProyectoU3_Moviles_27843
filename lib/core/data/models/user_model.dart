import 'package:turismo_app/core/data/models/preferences_model.dart';
import 'package:turismo_app/core/domain/entities/user.dart';

class UserModel {
  final String name;
  final String surname;
  final String email;
  final String? password;
  final PreferencesModel vector;

  UserModel({
    required this.name,
    required this.surname,
    required this.email,
    this.password,
    required this.vector,
  });

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
      password: json['password'] as String?,
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
      password: u.password,
      vector: PreferencesModel.fromEntity(u.vector),
    );
  }

  User toEntity() {
    return User(
      name: name,
      surname: surname,
      email: email,
      password: password,
      vector: vector.toEntity(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'surname': surname,
      'email': email,
      'password': password,
      'vector': vector.toJson(),
    };
  }
}
