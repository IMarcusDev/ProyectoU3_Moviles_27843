
import 'package:go_router/go_router.dart';
import 'package:turismo_app/features/ar_guide/pages/ar_cam_page.dart';
import 'package:turismo_app/features/map_exploration/presentation/pages/map_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MapPage(),
    ),
    GoRoute(
      path: '/ar',
      builder: (context, state) => const ArCamPage(),
    ),
  ],
);