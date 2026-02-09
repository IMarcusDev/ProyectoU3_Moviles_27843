import 'package:flutter_test/flutter_test.dart';
import 'package:turismo_app/core/domain/entities/preferences.dart';

void main() {
  group('Preferences Entity', () {
    test('should create Preferences with all fields', () {
      final preferences = Preferences(
        id: '123',
        hotel: 0.5,
        gastronomy: 0.7,
        nature: 0.9,
        culture: 0.3,
      );

      expect(preferences.id, '123');
      expect(preferences.hotel, 0.5);
      expect(preferences.gastronomy, 0.7);
      expect(preferences.nature, 0.9);
      expect(preferences.culture, 0.3);
    });

    test('should create empty Preferences', () {
      final preferences = Preferences.empty();

      expect(preferences.id, null);
      expect(preferences.hotel, 0);
      expect(preferences.gastronomy, 0);
      expect(preferences.nature, 0);
      expect(preferences.culture, 0);
    });

    test('should copy Preferences with new values', () {
      final preferences = Preferences(
        hotel: 0.2,
        gastronomy: 0.3,
        nature: 0.4,
        culture: 0.5,
      );

      final copied = preferences.copyWith(
        0.8, // hotel
        null, // gastronomy (keep original)
        0.9, // nature
        null, // culture (keep original)
      );

      expect(copied.hotel, 0.8);
      expect(copied.gastronomy, 0.3); // unchanged
      expect(copied.nature, 0.9);
      expect(copied.culture, 0.5); // unchanged
    });

    test('should validate if Preferences is valid (sum > 0)', () {
      final validPreferences = Preferences(
        hotel: 0.5,
        gastronomy: 0.5,
        nature: 0.0,
        culture: 0.0,
      );

      expect(validPreferences.isValid(), true);
    });

    test('should validate if Preferences is invalid (sum = 0)', () {
      final invalidPreferences = Preferences.empty();

      expect(invalidPreferences.isValid(), false);
    });

    test('should convert Preferences to list', () {
      final preferences = Preferences(
        hotel: 0.1,
        gastronomy: 0.2,
        nature: 0.3,
        culture: 0.4,
      );

      final list = preferences.toList();

      expect(list, [0.1, 0.2, 0.3, 0.4]);
      expect(list.length, 4);
    });

    test('should create Preferences from list', () {
      final list = [0.5, 0.6, 0.7, 0.8];

      final preferences = Preferences.fromList(list);

      expect(preferences.hotel, 0.5);
      expect(preferences.gastronomy, 0.6);
      expect(preferences.nature, 0.7);
      expect(preferences.culture, 0.8);
    });

    test('should maintain correct order when converting to and from list', () {
      final original = Preferences(
        hotel: 0.25,
        gastronomy: 0.35,
        nature: 0.45,
        culture: 0.55,
      );

      final list = original.toList();
      final reconstructed = Preferences.fromList(list);

      expect(reconstructed.hotel, original.hotel);
      expect(reconstructed.gastronomy, original.gastronomy);
      expect(reconstructed.nature, original.nature);
      expect(reconstructed.culture, original.culture);
    });
  });
}
