import 'package:flutter_test/flutter_test.dart';
import 'package:turismo_app/core/data/models/preferences_model.dart';
import 'package:turismo_app/core/domain/entities/preferences.dart';

void main() {
  group('PreferencesModel', () {
    test('should create empty PreferencesModel', () {
      final preferences = PreferencesModel.empty();

      expect(preferences.hotel, 0);
      expect(preferences.gastronomy, 0);
      expect(preferences.nature, 0);
      expect(preferences.culture, 0);
    });

    test('should create PreferencesModel from JSON correctly', () {
      final json = {
        'hotel': 0.5,
        'gastronomy': 0.8,
        'nature': 0.3,
        'culture': 0.9,
      };

      final preferences = PreferencesModel.fromJson(json);

      expect(preferences.hotel, 0.5);
      expect(preferences.gastronomy, 0.8);
      expect(preferences.nature, 0.3);
      expect(preferences.culture, 0.9);
    });

    test('should handle integer values in JSON', () {
      final json = {
        'hotel': 1,
        'gastronomy': 2,
        'nature': 3,
        'culture': 4,
      };

      final preferences = PreferencesModel.fromJson(json);

      expect(preferences.hotel, 1.0);
      expect(preferences.gastronomy, 2.0);
      expect(preferences.nature, 3.0);
      expect(preferences.culture, 4.0);
    });

    test('should convert PreferencesModel to JSON correctly', () {
      final preferences = PreferencesModel(
        hotel: 0.6,
        gastronomy: 0.7,
        nature: 0.8,
        culture: 0.9,
      );

      final json = preferences.toJson();

      expect(json['hotel'], 0.6);
      expect(json['gastronomy'], 0.7);
      expect(json['nature'], 0.8);
      expect(json['culture'], 0.9);
    });

    test('should create PreferencesModel from Preferences entity', () {
      final preferences = Preferences(
        hotel: 0.4,
        gastronomy: 0.5,
        nature: 0.6,
        culture: 0.7,
      );

      final model = PreferencesModel.fromEntity(preferences);

      expect(model.hotel, 0.4);
      expect(model.gastronomy, 0.5);
      expect(model.nature, 0.6);
      expect(model.culture, 0.7);
    });

    test('should convert PreferencesModel to Preferences entity', () {
      final model = PreferencesModel(
        hotel: 0.2,
        gastronomy: 0.3,
        nature: 0.4,
        culture: 0.5,
      );

      final preferences = model.toEntity();

      expect(preferences.hotel, 0.2);
      expect(preferences.gastronomy, 0.3);
      expect(preferences.nature, 0.4);
      expect(preferences.culture, 0.5);
    });

    test('should copy PreferencesModel with new values', () {
      final preferences = PreferencesModel(
        hotel: 0.1,
        gastronomy: 0.2,
        nature: 0.3,
        culture: 0.4,
      );

      final copied = preferences.copyWith(
        0.9, // hotel
        null, // gastronomy (keep original)
        0.8, // nature
        null, // culture (keep original)
      );

      expect(copied.hotel, 0.9);
      expect(copied.gastronomy, 0.2); // unchanged
      expect(copied.nature, 0.8);
      expect(copied.culture, 0.4); // unchanged
    });

    test('copyWith should keep original values when null parameters are provided', () {
      final preferences = PreferencesModel(
        hotel: 0.5,
        gastronomy: 0.6,
        nature: 0.7,
        culture: 0.8,
      );

      final copied = preferences.copyWith(null, null, null, null);

      expect(copied.hotel, 0.5);
      expect(copied.gastronomy, 0.6);
      expect(copied.nature, 0.7);
      expect(copied.culture, 0.8);
    });
  });
}
