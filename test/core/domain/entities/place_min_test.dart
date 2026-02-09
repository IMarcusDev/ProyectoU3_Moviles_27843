import 'package:flutter_test/flutter_test.dart';
import 'package:turismo_app/core/domain/entities/place_min.dart';

void main() {
  group('PlaceMin Entity', () {
    test('should create PlaceMin with all required fields', () {
      final now = DateTime.now();
      final placeMin = PlaceMin(
        id: 'pm123',
        name: 'Tourist Spot',
        lastScanned: now,
      );

      expect(placeMin.id, 'pm123');
      expect(placeMin.name, 'Tourist Spot');
      expect(placeMin.lastScanned, now);
    });

    test('should store and retrieve DateTime correctly', () {
      final specificDate = DateTime(2024, 1, 15, 14, 30, 0);
      final placeMin = PlaceMin(
        id: 'pm456',
        name: 'Historic Site',
        lastScanned: specificDate,
      );

      expect(placeMin.lastScanned.year, 2024);
      expect(placeMin.lastScanned.month, 1);
      expect(placeMin.lastScanned.day, 15);
      expect(placeMin.lastScanned.hour, 14);
      expect(placeMin.lastScanned.minute, 30);
    });

    test('should handle different PlaceMin instances', () {
      final now = DateTime.now();
      final placeMin1 = PlaceMin(
        id: 'pm789',
        name: 'Beach',
        lastScanned: now,
      );

      final placeMin2 = PlaceMin(
        id: 'pm790',
        name: 'Museum',
        lastScanned: now,
      );

      expect(placeMin1.id, isNot(equals(placeMin2.id)));
      expect(placeMin1.name, isNot(equals(placeMin2.name)));
    });

    test('should handle places scanned at different times', () {
      final earlier = DateTime(2024, 1, 1, 10, 0, 0);
      final later = DateTime(2024, 1, 2, 10, 0, 0);

      final placeMin1 = PlaceMin(
        id: 'pm101',
        name: 'Place A',
        lastScanned: earlier,
      );

      final placeMin2 = PlaceMin(
        id: 'pm102',
        name: 'Place B',
        lastScanned: later,
      );

      expect(placeMin1.lastScanned.isBefore(placeMin2.lastScanned), true);
      expect(placeMin2.lastScanned.isAfter(placeMin1.lastScanned), true);
    });

    test('should work with recent timestamps', () {
      final veryRecent = DateTime.now().subtract(Duration(seconds: 30));
      final placeMin = PlaceMin(
        id: 'pm202',
        name: 'Just Scanned Place',
        lastScanned: veryRecent,
      );

      final difference = DateTime.now().difference(placeMin.lastScanned);
      expect(difference.inMinutes, lessThan(1));
    });
  });
}
