import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:turismo_app/core/utils/logic/vector_utils.dart';

void main() {
  group('VectorUtils', () {
    group('normalize', () {
      test('should normalize a simple vector correctly', () {
        final vector = [3.0, 4.0];

        final normalized = VectorUtils.normalize(vector);

        final norm = sqrt(
          normalized.map((e) => e * e).reduce((a, b) => a + b),
        );

        expect(norm, closeTo(1.0, 1e-9));
        expect(normalized[0], closeTo(0.6, 1e-9));
        expect(normalized[1], closeTo(0.8, 1e-9));
      });

      test('should normalize a unit vector to itself', () {
        final vector = [1.0, 0.0];

        final normalized = VectorUtils.normalize(vector);

        expect(normalized[0], closeTo(1.0, 1e-9));
        expect(normalized[1], closeTo(0.0, 1e-9));
      });

      test('should normalize multi-dimensional vectors', () {
        final vector = [1.0, 2.0, 2.0];

        final normalized = VectorUtils.normalize(vector);

        final norm = sqrt(
          normalized.map((e) => e * e).reduce((a, b) => a + b),
        );

        expect(norm, closeTo(1.0, 1e-9));
        expect(normalized[0], closeTo(1.0 / 3.0, 1e-9));
        expect(normalized[1], closeTo(2.0 / 3.0, 1e-9));
        expect(normalized[2], closeTo(2.0 / 3.0, 1e-9));
      });

      test('should throw exception when normalizing zero vector', () {
        final vector = [0.0, 0.0];

        expect(
          () => VectorUtils.normalize(vector),
          throwsException,
        );
      });

      test('should handle negative values correctly', () {
        final vector = [-3.0, 4.0];

        final normalized = VectorUtils.normalize(vector);

        final norm = sqrt(
          normalized.map((e) => e * e).reduce((a, b) => a + b),
        );

        expect(norm, closeTo(1.0, 1e-9));
        expect(normalized[0], closeTo(-0.6, 1e-9));
        expect(normalized[1], closeTo(0.8, 1e-9));
      });
    });

    group('cosineSimilarity', () {
      test('should return 1.0 for identical vectors', () {
        final vectorA = [1.0, 2.0, 3.0];
        final vectorB = [1.0, 2.0, 3.0];

        final similarity = VectorUtils.cosineSimilarity(vectorA, vectorB);

        expect(similarity, closeTo(1.0, 1e-9));
      });

      test('should return 0.0 for orthogonal vectors', () {
        final vectorA = [1.0, 0.0];
        final vectorB = [0.0, 1.0];

        final similarity = VectorUtils.cosineSimilarity(vectorA, vectorB);

        expect(similarity, closeTo(0.0, 1e-9));
      });

      test('should return -1.0 for opposite vectors', () {
        final vectorA = [1.0, 2.0, 3.0];
        final vectorB = [-1.0, -2.0, -3.0];

        final similarity = VectorUtils.cosineSimilarity(vectorA, vectorB);

        expect(similarity, closeTo(-1.0, 1e-9));
      });

      test('should calculate similarity for different magnitude vectors', () {
        final vectorA = [1.0, 2.0, 3.0];
        final vectorB = [2.0, 4.0, 6.0]; // Same direction, different magnitude

        final similarity = VectorUtils.cosineSimilarity(vectorA, vectorB);

        expect(similarity, closeTo(1.0, 1e-9));
      });

      test('should calculate similarity for partially similar vectors', () {
        final vectorA = [1.0, 1.0, 0.0];
        final vectorB = [1.0, 0.0, 0.0];

        final similarity = VectorUtils.cosineSimilarity(vectorA, vectorB);

        expect(similarity, closeTo(1.0 / sqrt(2), 1e-9));
      });

      test('should handle preference vectors correctly', () {
        // Simulating user and place preference vectors
        final userPreferences = [0.5, 0.8, 0.3, 0.9]; // hotel, gastronomy, nature, culture
        final placeVector = [0.2, 0.9, 0.1, 0.7];

        final similarity = VectorUtils.cosineSimilarity(
          userPreferences,
          placeVector,
        );

        expect(similarity, greaterThan(0.0));
        expect(similarity, lessThanOrEqualTo(1.0));
      });

      test('should handle zero values in vectors', () {
        final vectorA = [0.0, 1.0, 2.0];
        final vectorB = [0.0, 2.0, 1.0];

        final similarity = VectorUtils.cosineSimilarity(vectorA, vectorB);

        expect(similarity, greaterThan(0.0));
        expect(similarity, lessThan(1.0));
      });
    });
  });
}