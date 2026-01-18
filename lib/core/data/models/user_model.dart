import 'package:turismo_app/core/domain/entities/user.dart';

class UserModel {
  final String? id;
  final String name;
  final String surname;
  final String email;
  final String? password;

  UserModel({
    this.id,
    required this.name,
    required this.surname,
    required this.email,
    this.password,
  });

  UserModel copyWith({
    String? name,
    String? surname,
    String? email,
  }) {
    return UserModel(
      name: name ?? this.name,
      surname: surname ?? this.surname,
      email: email ?? this.email,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String?,
      name: json['name'] as String,
      surname: json['surname'] as String,
      email: json['email'] as String,
      password: json['password'] as String?,
    );
  }

  factory UserModel.fromEntity(User u) {
    return UserModel(
      id: u.id,
      name: u.name,
      surname: u.surname,
      email: u.email,
      password: u.password,
    );
  }

  User toEntity() {
    return User(
      id: id,
      name: name,
      surname: surname,
      email: email,
      password: password,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // No Id
      'name': name,
      'surname': surname,
      'email': email,
      'password': password,
    };
  }
}
