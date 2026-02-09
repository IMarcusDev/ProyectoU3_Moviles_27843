import 'package:flutter_test/flutter_test.dart';
import 'package:turismo_app/features/map_exploration/domain/entities/tourist_place.dart';

void main() {
  group('TouristPlace Entity', () {
    test('should create TouristPlace with all fields', () {
      final touristPlace = TouristPlace(
        id: 'tp123',
        name: 'Beautiful Beach',
        description: 'A stunning beach with clear waters',
        latitude: 25.5,
        longitude: -100.5,
        imageUrls: ['url1.jpg', 'url2.jpg'],
        rating: 4.5,
        ratingCount: 120,
        category: 'Nature',
        interestVector: {
          'hotel': 0.2,
          'gastronomy': 0.3,
          'nature': 0.9,
          'culture': 0.1,
        },
      );

      expect(touristPlace.id, 'tp123');
      expect(touristPlace.name, 'Beautiful Beach');
      expect(touristPlace.description, 'A stunning beach with clear waters');
      expect(touristPlace.latitude, 25.5);
      expect(touristPlace.longitude, -100.5);
      expect(touristPlace.imageUrls, ['url1.jpg', 'url2.jpg']);
      expect(touristPlace.rating, 4.5);
      expect(touristPlace.ratingCount, 120);
      expect(touristPlace.category, 'Nature');
      expect(touristPlace.interestVector['nature'], 0.9);
    });

    test('should use Equatable for equality comparison', () {
      final place1 = TouristPlace(
        id: 'tp456',
        name: 'Museum',
        description: 'Historic museum',
        latitude: 30.0,
        longitude: -90.0,
        imageUrls: [],
        rating: 4.0,
        ratingCount: 50,
        category: 'Culture',
        interestVector: {},
      );

      final place2 = TouristPlace(
        id: 'tp456',
        name: 'Museum',
        description: 'Historic museum',
        latitude: 30.0,
        longitude: -90.0,
        imageUrls: [],
        rating: 4.0,
        ratingCount: 50,
        category: 'Culture',
        interestVector: {},
      );

      expect(place1, equals(place2));
      expect(place1.hashCode, equals(place2.hashCode));
    });

    test('should not be equal when ids are different', () {
      final place1 = TouristPlace(
        id: 'tp789',
        name: 'Park',
        description: 'City park',
        latitude: 25.0,
        longitude: -85.0,
        imageUrls: [],
        rating: 3.5,
        ratingCount: 30,
        category: 'Nature',
        interestVector: {},
      );

      final place2 = TouristPlace(
        id: 'tp790',
        name: 'Park',
        description: 'City park',
        latitude: 25.0,
        longitude: -85.0,
        imageUrls: [],
        rating: 3.5,
        ratingCount: 30,
        category: 'Nature',
        interestVector: {},
      );

      expect(place1, isNot(equals(place2)));
    });

    test('should not be equal when ratings are different', () {
      final place1 = TouristPlace(
        id: 'tp101',
        name: 'Restaurant',
        description: 'Fine dining',
        latitude: 28.0,
        longitude: -88.0,
        imageUrls: [],
        rating: 4.5,
        ratingCount: 100,
        category: 'Gastronomy',
        interestVector: {},
      );

      final place2 = TouristPlace(
        id: 'tp101',
        name: 'Restaurant',
        description: 'Fine dining',
        latitude: 28.0,
        longitude: -88.0,
        imageUrls: [],
        rating: 4.0,
        ratingCount: 100,
        category: 'Gastronomy',
        interestVector: {},
      );

      expect(place1, isNot(equals(place2)));
    });

    test('should handle empty imageUrls list', () {
      final touristPlace = TouristPlace(
        id: 'tp202',
        name: 'New Place',
        description: 'Recently added',
        latitude: 20.0,
        longitude: -80.0,
        imageUrls: [],
        rating: 0.0,
        ratingCount: 0,
        category: 'Other',
        interestVector: {},
      );

      expect(touristPlace.imageUrls, isEmpty);
      expect(touristPlace.rating, 0.0);
      expect(touristPlace.ratingCount, 0);
    });

    test('should handle complex interestVector', () {
      final touristPlace = TouristPlace(
        id: 'tp303',
        name: 'Mixed Place',
        description: 'Multiple interests',
        latitude: 22.0,
        longitude: -82.0,
        imageUrls: ['image.jpg'],
        rating: 4.2,
        ratingCount: 75,
        category: 'Mixed',
        interestVector: {
          'hotel': 0.5,
          'gastronomy': 0.7,
          'nature': 0.6,
          'culture': 0.8,
          'adventure': 0.9,
        },
      );

      expect(touristPlace.interestVector.length, 5);
      expect(touristPlace.interestVector['adventure'], 0.9);
      expect(touristPlace.interestVector['nonexistent'], null);
    });
  });
}
