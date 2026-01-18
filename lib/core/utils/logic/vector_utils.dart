import 'dart:math';

class VectorUtils {
  static List<double> normalize(List<double> vector) {
    final norm = sqrt(
      vector
          .map((e) => e * e)
          .reduce((a, b) => a + b)
    );

    if (norm == 0) {
      throw Exception('No se puede normalizar el vector cero');
    }

    return vector.map((e) => e / norm).toList();
  }
}
