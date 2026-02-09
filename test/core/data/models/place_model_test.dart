import 'package:flutter_test/flutter_test.dart';
import 'package:turismo_app/core/data/models/place_model.dart';
import 'package:turismo_app/core/data/models/preferences_model.dart';
import 'package:turismo_app/core/domain/entities/place.dart';
import 'package:turismo_app/core/domain/entities/preferences.dart';

void main() {
  group('PlaceModel', () {
    test('should create PlaceModel from JSON correctly', () {
      final json = {
        'id': 'place123',
        'name': 'Beautiful Beach',
        'description': 'A stunning beach with clear waters',
        'latitude': 25.5,
        'longitude': -100.5,
        'interestVector': {
          'hotel': 0.2,
          'gastronomy': 0.3,
          'nature': 0.9,
          'culture': 0.1,
        },
      };

      final placeModel = PlaceModel.fromJson(json);

      expect(placeModel.id, 'place123');
      expect(placeModel.name, 'Beautiful Beach');
      expect(placeModel.description, 'A stunning beach with clear waters');
      expect(placeModel.latitude, 25.5);
      expect(placeModel.longitude, -100.5);
      expect(placeModel.vector.nature, 0.9);
      expect(placeModel.vector.hotel, 0.2);
    });

    test('should handle integer coordinates in JSON', () {
      final json = {
        'name': 'Mountain Peak',
        'description': 'High mountain',
        'latitude': 25,
        'longitude': -100,
        'interestVector': {
          'hotel': 0.0,
          'gastronomy': 0.0,
          'nature': 1.0,
          'culture': 0.0,
        },
      };

      final placeModel = PlaceModel.fromJson(json);

      expect(placeModel.latitude, 25.0);
      expect(placeModel.longitude, -100.0);
    });

    test('should convert PlaceModel to JSON correctly', () {
      final placeModel = PlaceModel(
        id: 'place456',
        name: 'Historic Museum',
        description: 'Ancient artifacts',
        latitude: 30.5,
        longitude: -90.5,
        vector: PreferencesModel(
          hotel: 0.1,
          gastronomy: 0.2,
          nature: 0.0,
          culture: 1.0,
        ),
      );

      final json = placeModel.toJson();

      expect(json['name'], 'Historic Museum');
      expect(json['description'], 'Ancient artifacts');
      expect(json['latitude'], 30.5);
      expect(json['longitude'], -90.5);
      expect(json['interestVector']['culture'], 1.0);
      expect(json['id'], null); // ID is not included in toJson
    });

    test('should create PlaceModel from Place entity', () {
      final place = Place(
        id: 'place789',
        name: 'City Park',
        description: 'Beautiful urban park',
        latitude: 28.5,
        longitude: -85.5,
        vector: Preferences(
          hotel: 0.0,
          gastronomy: 0.3,
          nature: 0.8,
          culture: 0.2,
        ),
      );

      final placeModel = PlaceModel.fromEntity(place);

      expect(placeModel.id, 'place789');
      expect(placeModel.name, 'City Park');
      expect(placeModel.description, 'Beautiful urban park');
      expect(placeModel.latitude, 28.5);
      expect(placeModel.longitude, -85.5);
      expect(placeModel.vector.nature, 0.8);
    });

    test('should convert PlaceModel to Place entity', () {
      final placeModel = PlaceModel(
        id: 'place101',
        name: 'Restaurant Street',
        description: 'Famous food district',
        latitude: 32.5,
        longitude: -95.5,
        vector: PreferencesModel(
          hotel: 0.2,
          gastronomy: 1.0,
          nature: 0.0,
          culture: 0.3,
        ),
      );

      final place = placeModel.toEntity();

      expect(place.id, 'place101');
      expect(place.name, 'Restaurant Street');
      expect(place.description, 'Famous food district');
      expect(place.latitude, 32.5);
      expect(place.longitude, -95.5);
      expect(place.vector.gastronomy, 1.0);
    });

    test('should convert PlaceModel with null id to Place entity with empty string', () {
      final placeModel = PlaceModel(
        name: 'New Place',
        description: 'A new place',
        latitude: 20.0,
        longitude: -80.0,
        vector: PreferencesModel.empty(),
      );

      final place = placeModel.toEntity();

      expect(place.id, '');
    });

    test('should copy PlaceModel with new values', () {
      final placeModel = PlaceModel(
        id: 'place202',
        name: 'Old Name',
        description: 'Old description',
        latitude: 25.0,
        longitude: -100.0,
        vector: PreferencesModel.empty(),
      );

      final copied = placeModel.copyWith(
        name: 'New Name',
        latitude: 26.0,
      );

      expect(copied.id, 'place202'); // unchanged
      expect(copied.name, 'New Name');
      expect(copied.description, 'Old description'); // unchanged
      expect(copied.latitude, 26.0);
      expect(copied.longitude, -100.0); // unchanged
    });

    test('copyWith should keep original values when no parameters are provided', () {
      final placeModel = PlaceModel(
        id: 'place303',
        name: 'Test Place',
        description: 'Test description',
        latitude: 15.0,
        longitude: -75.0,
        vector: PreferencesModel(
          hotel: 0.5,
          gastronomy: 0.5,
          nature: 0.5,
          culture: 0.5,
        ),
      );

      final copied = placeModel.copyWith();

      expect(copied.id, 'place303');
      expect(copied.name, 'Test Place');
      expect(copied.description, 'Test description');
      expect(copied.latitude, 15.0);
      expect(copied.longitude, -75.0);
      expect(copied.vector.hotel, 0.5);
    });
  });
}
