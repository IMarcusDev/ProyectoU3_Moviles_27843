import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:turismo_app/core/data/datasources/firebase_place_datasource.dart';
import 'package:turismo_app/core/data/repositories/place_repository_impl.dart';
import 'package:turismo_app/core/domain/repositories/place_repository.dart';
import 'package:turismo_app/core/presentation/widgets/tourist_place_panel.dart';
import 'package:turismo_app/core/utils/theme/theme_colors.dart';
import 'package:turismo_app/core/utils/theme/app_spacing.dart';
import 'package:turismo_app/core/presentation/providers/auth_provider.dart';
import 'package:turismo_app/core/data/repositories/place_min_repository_impl.dart';
import 'package:turismo_app/core/domain/entities/place_min.dart';
import 'package:turismo_app/core/domain/repositories/place_min_repository.dart';
import 'package:turismo_app/features/menu/presentation/widgets/quick_action_button.dart';
import 'package:turismo_app/core/presentation/widgets/tourist_place_tile.dart';
import 'package:turismo_app/core/navigation/app_navigation.dart';

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
        title: const Text(
          'Inicio',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: ThemeColors.textPrimary,
          ),
        ),
        backgroundColor: ThemeColors.bgColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con bienvenida
              _buildWelcomeHeader(user.name, user.surname),

              const SizedBox(height: AppSpacing.sectionSpacing),

              // Acciones rápidas
              _buildQuickActions(context),

              const SizedBox(height: AppSpacing.sectionSpacing),

              // Sección de recientes
              _buildSectionHeader('Lugares Recientes'),

              const SizedBox(height: AppSpacing.lg),

              // Lista de lugares
              Expanded(
                child: FutureBuilder<List<PlaceMin>>(
                  future: _loadPlaces(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildLoadingState();
                    }

                    if (snapshot.hasError) {
                      return _buildErrorState();
                    }

                    final places = snapshot.data ?? [];

                    if (places.isEmpty) {
                      return _buildEmptyState(context);
                    }

                    return _buildPlacesList(context, places);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader(String name, String surname) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hola, $name 👋',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: ThemeColors.textPrimary,
            height: 1.2,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        const Text(
          'Descubre lugares increíbles cerca de ti',
          style: TextStyle(
            fontSize: 14,
            color: ThemeColors.textSecondary,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: QuickActionButton(
                icon: Icons.map_outlined,
                label: 'Explorar Mapa',
                onTap: () => context.push('/map'),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: QuickActionButton(
                icon: Icons.person_outline,
                label: 'Mi Perfil',
                onTap: () => AppNavigation.of(context).goToProfile(),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: ThemeColors.textPrimary,
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            color: ThemeColors.primaryGreen,
            strokeWidth: 3,
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text(
            'Cargando lugares...',
            style: TextStyle(
              fontSize: 14,
              color: ThemeColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: ThemeColors.error.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline,
              size: AppSpacing.iconXLarge,
              color: ThemeColors.error,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text(
            'Error al cargar lugares',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: ThemeColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'Por favor, intenta nuevamente',
            style: TextStyle(
              fontSize: 14,
              color: ThemeColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: ThemeColors.primaryGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.explore_outlined,
                size: 64,
                color: ThemeColors.primaryGreen,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            const Text(
              'No hay lugares recientes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: ThemeColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Escanea códigos QR para descubrir lugares increíbles cerca de ti',
              style: TextStyle(
                fontSize: 14,
                color: ThemeColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            ElevatedButton.icon(
              onPressed: () => AppNavigation.of(context).goToAR(),
              icon: const Icon(Icons.qr_code_scanner, size: 20),
              label: const Text('Abrir Escáner'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeColors.primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.md,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlacesList(BuildContext context, List<PlaceMin> places) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: places.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.listItemSpacing),
      itemBuilder: (context, index) {
        final place = places[index];

        return TouristPlaceTile(
          place: place,
          onTap: () async {
            final p = await repo.fetchPlace(place.id);

            if (p == null) return;

            if (!context.mounted) return;

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
  }
}
