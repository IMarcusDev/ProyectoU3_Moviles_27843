import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:turismo_app/core/utils/theme/theme_colors.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                applicationName: 'Turismo App',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.travel_explore),
                children: const [
                  Text(
                    'Aplicación de turismo para explorar destinos, mapas y experiencias locales.',
                  ),
                ],
              );
            },
          ),
          IconButton(
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout, color: ThemeColors.error,),
            onPressed: () {
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
                  'Nombre Apellido',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: ThemeColors.textPrimary,
                  ),
                ),
                Text(
                  'email@ejemplo.com',
                  style: TextStyle(
                    fontSize: 14,
                    color: ThemeColors.textSecondary,
                  ),
                ),
              ],
            ),

            Column(
              spacing: 12,
              children: const [
                _ProfileItem(
                  icon: Icons.person_outline,
                  label: 'Nombre',
                  value: 'Nombre',
                ),
                _ProfileItem(
                  icon: Icons.badge_outlined,
                  label: 'Apellido',
                  value: 'Apellido',
                ),
                _ProfileItem(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: 'email@ejemplo.com',
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
          const SizedBox(width: 12), // ← aquí SÍ es correcto usarlo (Row)
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
