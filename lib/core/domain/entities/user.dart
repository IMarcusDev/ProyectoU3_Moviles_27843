import 'package:turismo_app/core/domain/entities/preferences.dart';

class User {
  final String name;
  final String surname;
  final String email;
  final Preferences vector;

  User({
    required this.name,
    required this.surname,
    required this.email,
    required this.vector,
  });

  // New Users
  factory User.create(
    String name,
    String surname,
    String email,
  ) {
    return User(
      name: name,
      surname: surname,
      email: email,
      vector: Preferences.empty(),
    );
  }

  User copyWith(
    String? name,
    String? surname,
    String? email,
    Preferences? vector
  ) {
    return User(
      name: name ?? this.name,
      surname: surname ?? this.surname,
      email: email ?? this.email,
      vector: vector ?? this.vector,
    );
  }

  static int getEmptyId() {
    return -1;
  }
}
