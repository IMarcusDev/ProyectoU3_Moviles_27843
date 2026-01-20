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

  // Similitud por Coseno
  static double cosineSimilarity(List<double> a, List<double> b) {
    double dot = 0;
    double magA = 0;
    double magB = 0;

    for (int i = 0; i < a.length; i++) {
      dot += a[i] * b[i];
      magA += a[i] * a[i];
      magB += b[i] * b[i];
    }

    return dot / (sqrt(magA) * sqrt(magB));
  }
}
