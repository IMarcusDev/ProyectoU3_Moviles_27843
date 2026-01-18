class User {
  final String? id;
  final String name;
  final String surname;
  final String email;
  final String? password;

  User({
    this.id,
    required this.name,
    required this.surname,
    required this.email,
    this.password,
  });

  // New Users
  factory User.create(
    String name,
    String surname,
    String email,
    String password,
  ) {
    return User(
      name: name,
      surname: surname,
      email: email,
      password: password,
    );
  }

  User copyWith(
    String? name,
    String? surname,
    String? email,
  ) {
    return User(
      name: name ?? this.name,
      surname: surname ?? this.surname,
      email: email ?? this.email,
    );
  }
}
