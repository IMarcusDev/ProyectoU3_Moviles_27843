import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:turismo_app/core/data/datasources/firebase_place_datasource.dart';
import 'package:turismo_app/core/data/repositories/place_min_repository_impl.dart';
import 'package:turismo_app/core/data/repositories/place_repository_impl.dart';
import 'package:turismo_app/core/domain/repositories/place_min_repository.dart';
import 'package:turismo_app/core/domain/repositories/place_repository.dart';
import 'package:turismo_app/core/presentation/widgets/tourist_place_panel.dart';

class ArCamPage extends StatefulWidget {
  const ArCamPage({super.key});

  @override
  State<ArCamPage> createState() => _ArCamPageState();
}

class _ArCamPageState extends State<ArCamPage> {
  final PlaceRepository placeRepo = PlaceRepositoryImpl(datasource: FirebasePlaceDatasource());
  final PlaceMinRepository placeMinRepo = PlaceMinRepositoryImpl();

  bool _scanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MobileScanner(
        fit: BoxFit.cover,
        onDetect: (barcodeCapture) async {
          if (_scanned) return;

          final barcode = barcodeCapture.barcodes.first;
          final String? value = barcode.rawValue;

          if (value == null) return;

          _scanned = true;

          final place = await placeRepo.fetchPlace(value);
          if (place == null) {
            _scanned = false;
            return;
          }

          await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => TouristPlacePanel(place: place),
          );

          // When closed
          if (mounted) {
            setState(() {
              _scanned = false;
            });

            placeMinRepo.addPlace(place.toPlaceMin()!);
          }
        },
      ),
    );
  }
}
