import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:turismo_app/core/utils/logic/vector_utils.dart';

void main() {
  test('Utils Normalized Vector', () {
    final vector = [3.0, 4.0];

    final normalized = VectorUtils.normalize(vector);

    final norm = sqrt(
      normalized.map((e) => e * e).reduce((a, b) => a + b),
    );

    expect(norm, closeTo(1.0, 1e-9));

    expect(normalized[0], closeTo(0.6, 1e-9));
    expect(normalized[1], closeTo(0.8, 1e-9));
  });
}