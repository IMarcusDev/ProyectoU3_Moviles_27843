import 'package:geolocator/geolocator.dart';
import '../errors/failures.dart';

class LocationService {
  Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationFailure('El GPS está desactivado via Hardware.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw const LocationFailure('Permiso de ubicación denegado por el usuario.');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      throw const LocationFailure(
        'Permisos denegados permanentemente. Habilítalos en Ajustes.',
      );
    }
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}