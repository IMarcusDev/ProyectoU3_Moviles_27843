import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:turismo_app/core/presentation/providers/place_min_provider.dart';
import 'package:turismo_app/core/utils/theme/theme_colors.dart';
import 'package:turismo_app/core/presentation/providers/auth_provider.dart';

class UserPage extends ConsumerWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user!;

    return Scaffold(
      backgroundColor: ThemeColors.bgColor,
      appBar: AppBar(
        title: const Text('Perfil'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: ThemeColors.textPrimary,
        actions: [
          IconButton(
            tooltip: 'Acerca de',
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationName: 'EcuaMap',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.travel_explore),
                children: const [
                  Text(
                    'Aplicación de turismo para explorar destinos, mapas y experiencias locales. ',
                  ),
                  SizedBox(height: 16,),
                  Text('Desarrolladores:'),
                  Text('Mateo Sosa'),
                  Text('Marcos Escobar'),
                  Text('Fernando Sandoval')
                ],
              );
            },
          ),
          IconButton(
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout, color: ThemeColors.error,),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
              ref.read(viewedPlacesProvider.notifier).clearAll();

              context.go('/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          spacing: 24,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: ThemeColors.primaryGreen.withOpacity(0.15),
              child: Icon(
                Icons.person,
                size: 64,
                color: ThemeColors.primaryGreen,
              ),
            ),

            Column(
              spacing: 4,
              children: [
                Text(
                  '${user.name} ${user.surname}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: ThemeColors.textPrimary,
                  ),
                ),
                Text(
                  user.email,
                  style: TextStyle(
                    fontSize: 14,
                    color: ThemeColors.textSecondary,
                  ),
                ),
              ],
            ),

            Column(
              spacing: 12,
              children: [
                _ProfileItem(
                  icon: Icons.person_outline,
                  label: 'Nombre',
                  value: user.name,
                ),
                _ProfileItem(
                  icon: Icons.badge_outlined,
                  label: 'Apellido',
                  value: user.surname,
                ),
                _ProfileItem(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: user.email,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: ThemeColors.primaryGreen),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: ThemeColors.textSecondary,
              ),
            ),
          ),

          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: ThemeColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
