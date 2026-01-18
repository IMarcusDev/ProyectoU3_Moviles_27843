import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:turismo_app/core/domain/entities/place.dart';
import 'package:turismo_app/core/domain/entities/preferences.dart';
import 'package:turismo_app/core/presentation/widgets/tourist_place_panel.dart';
import 'package:turismo_app/core/utils/theme/theme_colors.dart';
import 'package:turismo_app/features/menu/presentation/widgets/quick_action_button.dart';
import 'package:turismo_app/features/menu/presentation/widgets/tourist_place_tile.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
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
              'Bienvenido',
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
              child: ListView.separated(
                itemCount: 5,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return TouristPlaceTile(
                    text: 'Lugar Turístico ${index + 1}',
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => TouristPlacePanel(
                          place: Place(
                            id: '',
                            name: 'Lugar 1',
                            description: 'Lugar de prueba',
                            latitude: -0.32,
                            longitude: -78.46,
                            vector: Preferences(
                              culture: 0,
                              hotel: 1,
                              gastronomy: 0,
                              nature: 0
                            ),
                          ),
                        ),
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
