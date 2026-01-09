import 'dart:math';

class GeoMath {
  static double calculateBearing(double startLat, double startLng, double endLat, double endLng) {
    var startLatRad = _degreesToRadians(startLat);
    var startLngRad = _degreesToRadians(startLng);
    var endLatRad = _degreesToRadians(endLat);
    var endLngRad = _degreesToRadians(endLng);

    var dLng = endLngRad - startLngRad;

    var y = sin(dLng) * cos(endLatRad);
    var x = cos(startLatRad) * sin(endLatRad) -
            sin(startLatRad) * cos(endLatRad) * cos(dLng);

    var bearingRad = atan2(y, x);
    var bearingDegrees = _radiansToDegrees(bearingRad);

    return (bearingDegrees + 360) % 360;
  }

  static double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 + 
            c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a)) * 1000;
  }

  static double _degreesToRadians(double degrees) => degrees * pi / 180;
  static double _radiansToDegrees(double radians) => radians * 180 / pi;
}