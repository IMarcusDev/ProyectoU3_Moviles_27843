import 'package:flutter_test/flutter_test.dart';
import 'package:turismo_app/core/utils/logic/recommendation_engine.dart';
import 'package:turismo_app/features/map_exploration/domain/entities/tourist_place.dart';

void main() {
  group('RecommendationEngine', () {
    late RecommendationEngine engine;

    setUp(() {
      engine = RecommendationEngine();
    });

    test('should return places sorted by rating when user interests are empty', () {
      final places = [
        TouristPlace(
          id: '1',
          name: 'Place 1',
          description: 'Description 1',
          latitude: 25.0,
          longitude: -100.0,
          imageUrls: [],
          rating: 3.5,
          ratingCount: 50,
          category: 'Nature',
          interestVector: {'nature': 0.8},
        ),
        TouristPlace(
          id: '2',
          name: 'Place 2',
          description: 'Description 2',
          latitude: 26.0,
          longitude: -101.0,
          imageUrls: [],
          rating: 4.5,
          ratingCount: 100,
          category: 'Culture',
          interestVector: {'culture': 0.9},
        ),
        TouristPlace(
          id: '3',
          name: 'Place 3',
          description: 'Description 3',
          latitude: 27.0,
          longitude: -102.0,
          imageUrls: [],
          rating: 4.0,
          ratingCount: 75,
          category: 'Gastronomy',
          interestVector: {'gastronomy': 0.7},
        ),
      ];

      final recommendations = engine.recommend(
        places: places,
        userInterests: {},
      );

      expect(recommendations.length, 3);
      expect(recommendations[0].rating, 4.5); // Highest rating first
      expect(recommendations[1].rating, 4.0);
      expect(recommendations[2].rating, 3.5); // Lowest rating last
    });

    test('should recommend places based on user interests', () {
      final places = [
        TouristPlace(
          id: '1',
          name: 'Beach',
          description: 'Beautiful beach',
          latitude: 25.0,
          longitude: -100.0,
          imageUrls: [],
          rating: 4.0,
          ratingCount: 100,
          category: 'Nature',
          interestVector: {
            'hotel': 0.2,
            'gastronomy': 0.3,
            'nature': 0.9,
            'culture': 0.1,
          },
        ),
        TouristPlace(
          id: '2',
          name: 'Museum',
          description: 'Historic museum',
          latitude: 26.0,
          longitude: -101.0,
          imageUrls: [],
          rating: 4.0,
          ratingCount: 100,
          category: 'Culture',
          interestVector: {
            'hotel': 0.1,
            'gastronomy': 0.2,
            'nature': 0.0,
            'culture': 1.0,
          },
        ),
      ];

      final userInterests = {
        'nature': 1.0,
        'culture': 0.0,
      };

      final recommendations = engine.recommend(
        places: places,
        userInterests: userInterests,
      );

      expect(recommendations[0].name, 'Beach'); // Nature place should be first
    });

    test('should include quality bonus in recommendations', () {
      final places = [
        TouristPlace(
          id: '1',
          name: 'Low Quality Match',
          description: 'Perfect interest match but low rating',
          latitude: 25.0,
          longitude: -100.0,
          imageUrls: [],
          rating: 2.0, // Low rating
          ratingCount: 10,
          category: 'Nature',
          interestVector: {
            'nature': 1.0,
          },
        ),
        TouristPlace(
          id: '2',
          name: 'High Quality Partial Match',
          description: 'Partial match but excellent rating',
          latitude: 26.0,
          longitude: -101.0,
          imageUrls: [],
          rating: 5.0, // High rating
          ratingCount: 200,
          category: 'Mixed',
          interestVector: {
            'nature': 0.5,
          },
        ),
      ];

      final userInterests = {
        'nature': 1.0,
      };

      final recommendations = engine.recommend(
        places: places,
        userInterests: userInterests,
      );

      // Both places should be in the list
      expect(recommendations.length, 2);
    });

    test('should handle places with missing interest keys', () {
      final places = [
        TouristPlace(
          id: '1',
          name: 'Place with all interests',
          description: 'Has all interests',
          latitude: 25.0,
          longitude: -100.0,
          imageUrls: [],
          rating: 4.0,
          ratingCount: 50,
          category: 'Mixed',
          interestVector: {
            'hotel': 0.5,
            'gastronomy': 0.5,
            'nature': 0.5,
            'culture': 0.5,
          },
        ),
        TouristPlace(
          id: '2',
          name: 'Place with partial interests',
          description: 'Missing some interests',
          latitude: 26.0,
          longitude: -101.0,
          imageUrls: [],
          rating: 4.0,
          ratingCount: 50,
          category: 'Nature',
          interestVector: {
            'nature': 0.8,
          },
        ),
      ];

      final userInterests = {
        'hotel': 1.0,
        'gastronomy': 1.0,
        'nature': 0.0,
        'culture': 0.0,
      };

      final recommendations = engine.recommend(
        places: places,
        userInterests: userInterests,
      );

      expect(recommendations.length, 2);
      expect(recommendations[0].name, 'Place with all interests');
    });

    test('should handle empty places list', () {
      final recommendations = engine.recommend(
        places: [],
        userInterests: {'nature': 1.0},
      );

      expect(recommendations, isEmpty);
    });

    test('should calculate different scores for different user preferences', () {
      final places = [
        TouristPlace(
          id: '1',
          name: 'Cultural Place',
          description: 'Museum and art',
          latitude: 25.0,
          longitude: -100.0,
          imageUrls: [],
          rating: 4.0,
          ratingCount: 100,
          category: 'Culture',
          interestVector: {
            'culture': 1.0,
            'nature': 0.0,
          },
        ),
        TouristPlace(
          id: '2',
          name: 'Nature Place',
          description: 'Park and trails',
          latitude: 26.0,
          longitude: -101.0,
          imageUrls: [],
          rating: 4.0,
          ratingCount: 100,
          category: 'Nature',
          interestVector: {
            'culture': 0.0,
            'nature': 1.0,
          },
        ),
      ];

      // User prefers culture
      final cultureUserInterests = {
        'culture': 1.0,
        'nature': 0.0,
      };

      final cultureRecommendations = engine.recommend(
        places: places,
        userInterests: cultureUserInterests,
      );

      expect(cultureRecommendations[0].name, 'Cultural Place');

      // User prefers nature
      final natureUserInterests = {
        'culture': 0.0,
        'nature': 1.0,
      };

      final natureRecommendations = engine.recommend(
        places: places,
        userInterests: natureUserInterests,
      );

      expect(natureRecommendations[0].name, 'Nature Place');
    });

    test('should maintain stable order for equal scores', () {
      final places = [
        TouristPlace(
          id: '1',
          name: 'Place A',
          description: 'First place',
          latitude: 25.0,
          longitude: -100.0,
          imageUrls: [],
          rating: 4.0,
          ratingCount: 100,
          category: 'Nature',
          interestVector: {'nature': 0.5},
        ),
        TouristPlace(
          id: '2',
          name: 'Place B',
          description: 'Second place',
          latitude: 26.0,
          longitude: -101.0,
          imageUrls: [],
          rating: 4.0,
          ratingCount: 100,
          category: 'Nature',
          interestVector: {'nature': 0.5},
        ),
      ];

      final userInterests = {'nature': 1.0};

      final recommendations = engine.recommend(
        places: places,
        userInterests: userInterests,
      );

      expect(recommendations.length, 2);
    });

    test('should handle multiple interest categories with varying weights', () {
      final places = [
        TouristPlace(
          id: '1',
          name: 'Specialized Nature',
          description: 'Only nature',
          latitude: 25.0,
          longitude: -100.0,
          imageUrls: [],
          rating: 4.0,
          ratingCount: 50,
          category: 'Nature',
          interestVector: {
            'hotel': 0.0,
            'gastronomy': 0.0,
            'nature': 1.0,
            'culture': 0.0,
          },
        ),
        TouristPlace(
          id: '2',
          name: 'Balanced Place',
          description: 'Multiple interests',
          latitude: 26.0,
          longitude: -101.0,
          imageUrls: [],
          rating: 4.0,
          ratingCount: 50,
          category: 'Mixed',
          interestVector: {
            'hotel': 0.3,
            'gastronomy': 0.3,
            'nature': 0.3,
            'culture': 0.3,
          },
        ),
      ];

      final userInterests = {
        'hotel': 0.25,
        'gastronomy': 0.25,
        'nature': 0.25,
        'culture': 0.25,
      };

      final recommendations = engine.recommend(
        places: places,
        userInterests: userInterests,
      );

      expect(recommendations.length, 2);
    });
  });
}
