import 'package:flutter_test/flutter_test.dart';
import 'package:turismo_app/core/domain/entities/place.dart';
import 'package:turismo_app/core/domain/entities/preferences.dart';

void main() {
  group('Place Entity', () {
    test('should create Place with all fields', () {
      final place = Place(
        id: 'place123',
        name: 'Beautiful Beach',
        description: 'A stunning beach',
        latitude: 25.5,
        longitude: -100.5,
        vector: Preferences(
          hotel: 0.2,
          gastronomy: 0.3,
          nature: 0.9,
          culture: 0.1,
        ),
      );

      expect(place.id, 'place123');
      expect(place.name, 'Beautiful Beach');
      expect(place.description, 'A stunning beach');
      expect(place.latitude, 25.5);
      expect(place.longitude, -100.5);
      expect(place.vector.nature, 0.9);
    });

    test('should create Place without id', () {
      final place = Place(
        name: 'Mountain Peak',
        description: 'High mountain',
        latitude: 30.0,
        longitude: -95.0,
        vector: Preferences.empty(),
      );

      expect(place.id, null);
      expect(place.name, 'Mountain Peak');
    });

    test('should convert Place to PlaceMin when id exists', () {
      final place = Place(
        id: 'place456',
        name: 'Historic Museum',
        description: 'Ancient artifacts',
        latitude: 28.0,
        longitude: -90.0,
        vector: Preferences(
          hotel: 0.1,
          gastronomy: 0.2,
          nature: 0.0,
          culture: 1.0,
        ),
      );

      final placeMin = place.toPlaceMin();

      expect(placeMin, isNotNull);
      expect(placeMin!.id, 'place456');
      expect(placeMin.name, 'Historic Museum');
      expect(placeMin.lastScanned, isA<DateTime>());
    });

    test('should return null when converting Place to PlaceMin without id', () {
      final place = Place(
        name: 'New Place',
        description: 'A new place',
        latitude: 20.0,
        longitude: -80.0,
        vector: Preferences.empty(),
      );

      final placeMin = place.toPlaceMin();

      expect(placeMin, null);
    });

    test('should create Place with different preference vectors', () {
      final hotelPlace = Place(
        id: 'hotel1',
        name: 'Luxury Hotel',
        description: 'Five-star accommodation',
        latitude: 25.0,
        longitude: -100.0,
        vector: Preferences(
          hotel: 1.0,
          gastronomy: 0.5,
          nature: 0.0,
          culture: 0.2,
        ),
      );

      final culturePlace = Place(
        id: 'culture1',
        name: 'Art Gallery',
        description: 'Modern art exhibition',
        latitude: 26.0,
        longitude: -101.0,
        vector: Preferences(
          hotel: 0.0,
          gastronomy: 0.1,
          nature: 0.0,
          culture: 1.0,
        ),
      );

      expect(hotelPlace.vector.hotel, 1.0);
      expect(culturePlace.vector.culture, 1.0);
      expect(hotelPlace.vector.hotel > culturePlace.vector.hotel, true);
    });
  });
}
