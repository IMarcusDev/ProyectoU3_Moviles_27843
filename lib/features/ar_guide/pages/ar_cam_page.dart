import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:turismo_app/features/map_exploration/domain/entities/tourist_place.dart';
import 'package:turismo_app/features/map_exploration/presentation/providers/map_providers.dart';
import '../../../../core/utils/geo_math.dart';

class ArCamPage extends ConsumerStatefulWidget {
  const ArCamPage({super.key});

  @override
  ConsumerState<ArCamPage> createState() => _ArCamPageState();
}

class _ArCamPageState extends ConsumerState<ArCamPage> {
  CameraController? _controller;
  double? _heading;

  @override
  void initState() {
    super.initState();
    _initCamera();
    _initCompass();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;
    _controller = CameraController(cameras[0], ResolutionPreset.high);
    await _controller!.initialize();
    if (mounted) setState(() {});
  }

  void _initCompass() {
    FlutterCompass.events?.listen((event) {
      if (mounted) {
        setState(() => _heading = event.heading);
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userLocationAsync = ref.watch(userLocationProvider);
    final placesAsync = ref.watch(filteredPlacesProvider);

    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: CameraPreview(_controller!),
          ),

          if (_heading != null)
            userLocationAsync.when(
              loading: () => const SizedBox(),
              error: (_, _) => const Center(child: Text("Sin GPS", style: TextStyle(color: Colors.white))),
              data: (userPos) {
                return placesAsync.when(
                  loading: () => const SizedBox(),
                  error: (_, _) => const SizedBox(),
                  data: (places) {
                    return Stack(
                      children: places.map((place) {
                        return _buildArTag(context, place, userPos.latitude, userPos.longitude);
                      }).toList(),
                    );
                  },
                );
              },
            ),

          Positioned(
            top: 40,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => context.pop(),
              ),
            ),
          ),

          Positioned(
            bottom: 20, 
            left: 20,
            child: Text(
              "Rumbo: ${_heading?.toStringAsFixed(0)}°", 
              style: const TextStyle(color: Colors.white, shadows: [Shadow(blurRadius: 2, color: Colors.black)]),
            )
          )
        ],
      ),
    );
  }

  Widget _buildArTag(BuildContext context, TouristPlace place, double userLat, double userLng) {
    final bearing = GeoMath.calculateBearing(userLat, userLng, place.latitude, place.longitude);

    double delta = bearing - (_heading ?? 0);
    while (delta < -180) delta += 360;
    while (delta > 180) delta -= 360;

    if (delta.abs() > 30) return const SizedBox();
    final screenWidth = MediaQuery.of(context).size.width;
    final double xPos = ((delta + 30) / 60) * screenWidth;

    final distance = GeoMath.calculateDistance(userLat, userLng, place.latitude, place.longitude);

    if (distance > 5000) return const SizedBox();

    return Positioned(
      left: xPos - 60,
      top: MediaQuery.of(context).size.height / 2 - 50,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)]
            ),
            child: Column(
              children: [
                Text(
                  place.name, 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "${distance.toStringAsFixed(0)} m", 
                  style: const TextStyle(fontSize: 10, color: Colors.indigo),
                ),
                // Estrellitas
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (i) => Icon(
                    i < place.rating ? Icons.star : Icons.star_border,
                    size: 10, color: Colors.amber,
                  )),
                )
              ],
            ),
          ),
          const Icon(Icons.arrow_drop_down, color: Colors.white, size: 30),
        ],
      ),
    );
  }
}