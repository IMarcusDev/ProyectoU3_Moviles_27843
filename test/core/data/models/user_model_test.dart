import 'package:flutter_test/flutter_test.dart';
import 'package:turismo_app/core/data/models/user_model.dart';
import 'package:turismo_app/core/domain/entities/user.dart';

void main() {
  group('UserModel', () {
    test('should create UserModel from JSON correctly', () {
      final json = {
        'id': '123',
        'name': 'John',
        'surname': 'Doe',
        'email': 'john.doe@example.com',
        'password': 'password123',
      };

      final userModel = UserModel.fromJson(json);

      expect(userModel.id, '123');
      expect(userModel.name, 'John');
      expect(userModel.surname, 'Doe');
      expect(userModel.email, 'john.doe@example.com');
      expect(userModel.password, 'password123');
    });

    test('should create UserModel from JSON without optional fields', () {
      final json = {
        'name': 'Jane',
        'surname': 'Smith',
        'email': 'jane.smith@example.com',
      };

      final userModel = UserModel.fromJson(json);

      expect(userModel.id, null);
      expect(userModel.name, 'Jane');
      expect(userModel.surname, 'Smith');
      expect(userModel.email, 'jane.smith@example.com');
      expect(userModel.password, null);
    });

    test('should convert UserModel to JSON correctly', () {
      final userModel = UserModel(
        id: '456',
        name: 'Alice',
        surname: 'Johnson',
        email: 'alice.johnson@example.com',
        password: 'securepass',
      );

      final json = userModel.toJson();

      expect(json['name'], 'Alice');
      expect(json['surname'], 'Johnson');
      expect(json['email'], 'alice.johnson@example.com');
      expect(json['password'], 'securepass');
      expect(json['id'], null); // ID is not included in toJson
    });

    test('should create UserModel from User entity', () {
      final user = User(
        id: '789',
        name: 'Bob',
        surname: 'Williams',
        email: 'bob.williams@example.com',
        password: 'pass123',
      );

      final userModel = UserModel.fromEntity(user);

      expect(userModel.id, '789');
      expect(userModel.name, 'Bob');
      expect(userModel.surname, 'Williams');
      expect(userModel.email, 'bob.williams@example.com');
      expect(userModel.password, 'pass123');
    });

    test('should convert UserModel to User entity', () {
      final userModel = UserModel(
        id: '101',
        name: 'Charlie',
        surname: 'Brown',
        email: 'charlie.brown@example.com',
        password: 'charlie123',
      );

      final user = userModel.toEntity();

      expect(user.id, '101');
      expect(user.name, 'Charlie');
      expect(user.surname, 'Brown');
      expect(user.email, 'charlie.brown@example.com');
      expect(user.password, 'charlie123');
    });

    test('should copy UserModel with new values', () {
      final userModel = UserModel(
        id: '202',
        name: 'David',
        surname: 'Miller',
        email: 'david.miller@example.com',
        password: 'david123',
      );

      final copiedUser = userModel.copyWith(
        name: 'Dave',
        email: 'dave.miller@example.com',
      );

      expect(copiedUser.name, 'Dave');
      expect(copiedUser.surname, 'Miller'); // unchanged
      expect(copiedUser.email, 'dave.miller@example.com');
    });

    test('copyWith should keep original values when no parameters are provided', () {
      final userModel = UserModel(
        id: '303',
        name: 'Eve',
        surname: 'Davis',
        email: 'eve.davis@example.com',
      );

      final copiedUser = userModel.copyWith();

      expect(copiedUser.name, 'Eve');
      expect(copiedUser.surname, 'Davis');
      expect(copiedUser.email, 'eve.davis@example.com');
    });
  });
}
