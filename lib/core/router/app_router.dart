import 'package:go_router/go_router.dart';
import 'package:turismo_app/core/router/app_page.dart';
import 'package:turismo_app/features/auth/presentation/pages/login_page.dart';
import 'package:turismo_app/features/auth/presentation/pages/register_page.dart';
import 'package:turismo_app/features/map_exploration/presentation/pages/map_page.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    // Auth
    GoRoute(
      path: '/login',
      builder: (_, __) => LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (_, __) => RegisterPage(),
    ),

    // App principal con navegación interna (PageView)
    GoRoute(
      path: '/app',
      builder: (_, __) => const AppPage(),
    ),

    // Map (fullscreen)
    GoRoute(
      path: '/map',
      builder: (_, __) => MapPage(),
    ),
  ],
);
