import 'package:flutter_test/flutter_test.dart';
import 'package:turismo_app/core/domain/entities/user.dart';

void main() {
  group('User Entity', () {
    test('should create User with all fields', () {
      final user = User(
        id: '123',
        name: 'John',
        surname: 'Doe',
        email: 'john.doe@example.com',
        password: 'password123',
      );

      expect(user.id, '123');
      expect(user.name, 'John');
      expect(user.surname, 'Doe');
      expect(user.email, 'john.doe@example.com');
      expect(user.password, 'password123');
    });

    test('should create User without optional fields', () {
      final user = User(
        name: 'Jane',
        surname: 'Smith',
        email: 'jane.smith@example.com',
      );

      expect(user.id, null);
      expect(user.name, 'Jane');
      expect(user.surname, 'Smith');
      expect(user.email, 'jane.smith@example.com');
      expect(user.password, null);
    });

    test('should create new User using factory method', () {
      final user = User.create(
        'Alice',
        'Johnson',
        'alice.johnson@example.com',
        'securepass',
      );

      expect(user.id, null);
      expect(user.name, 'Alice');
      expect(user.surname, 'Johnson');
      expect(user.email, 'alice.johnson@example.com');
      expect(user.password, 'securepass');
    });

    test('should copy User with new values', () {
      final user = User(
        id: '456',
        name: 'Bob',
        surname: 'Williams',
        email: 'bob.williams@example.com',
        password: 'pass123',
      );

      final copiedUser = user.copyWith(
        'Robert',
        null,
        'robert.williams@example.com',
      );

      expect(copiedUser.name, 'Robert');
      expect(copiedUser.surname, 'Williams'); // unchanged
      expect(copiedUser.email, 'robert.williams@example.com');
    });

    test('copyWith should keep original values when null parameters are provided', () {
      final user = User(
        id: '789',
        name: 'Charlie',
        surname: 'Brown',
        email: 'charlie.brown@example.com',
      );

      final copiedUser = user.copyWith(null, null, null);

      expect(copiedUser.name, 'Charlie');
      expect(copiedUser.surname, 'Brown');
      expect(copiedUser.email, 'charlie.brown@example.com');
    });
  });
}
