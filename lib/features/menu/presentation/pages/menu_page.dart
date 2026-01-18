import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:turismo_app/core/data/datasources/firebase_place_datasource.dart';
import 'package:turismo_app/core/data/repositories/place_repository_impl.dart';
import 'package:turismo_app/core/domain/repositories/place_repository.dart';
import 'package:turismo_app/core/presentation/widgets/tourist_place_panel.dart';
import 'package:turismo_app/core/utils/theme/theme_colors.dart';
import 'package:turismo_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:turismo_app/features/menu/data/repositories/place_min_repository_impl.dart';
import 'package:turismo_app/features/menu/domain/entities/place_min.dart';
import 'package:turismo_app/features/menu/domain/repositories/place_min_repository.dart';
import 'package:turismo_app/features/menu/presentation/widgets/quick_action_button.dart';
import 'package:turismo_app/features/menu/presentation/widgets/tourist_place_tile.dart';

class MenuPage extends ConsumerWidget {
  final PlaceRepository repo = PlaceRepositoryImpl(datasource: FirebasePlaceDatasource());
  final PlaceMinRepository _minRepo = PlaceMinRepositoryImpl();

  MenuPage({super.key});

  Future<List<PlaceMin>> _loadPlaces() {
    return _minRepo.getLimitViewedUniquePlaces(5);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user!;

    return Scaffold(
      backgroundColor: ThemeColors.bgColor,
      appBar: AppBar(
        title: const Text('Inicio'),
        backgroundColor: ThemeColors.bgColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 24,
          children: [
            // Header
            Text(
              'Bienvenido ${user.name} ${user.surname}',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: ThemeColors.textPrimary,
              ),
            ),

            // Fast actions
            Row(
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: QuickActionButton(
                    icon: Icons.map_outlined,
                    label: 'Mapa',
                    onTap: () {
                      context.push('/map');
                    },
                  ),
                ),
                Expanded(
                  child: QuickActionButton(
                    icon: Icons.person_outline,
                    label: 'Perfil',
                    onTap: () {
                      context.go('/profile');
                    },
                  ),
                ),
              ],
            ),

            // Recent section
            Text(
              'Recientes',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: ThemeColors.textPrimary,
              ),
            ),

            // List
            Expanded(
              child: FutureBuilder<List<PlaceMin>>(
                future: _loadPlaces(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(child: Text('Error al cargar lugares'));
                  }

                  final places = snapshot.data ?? [];

                  if (places.isEmpty) {
                    return const Center(child: Text('No hay lugares recientes. Prueba escaneando QRs.'));
                  }

                  return ListView.separated(
                    itemCount: places.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final place = places[index];

                      return TouristPlaceTile(
                        place: place,
                        onTap: () async {
                          final p = await repo.fetchPlace(place.id);

                          if (p == null) return;

                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => TouristPlacePanel(place: p),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
