import 'package:go_router/go_router.dart';
import 'package:turismo_app/core/router/app_page.dart';
import 'package:turismo_app/features/ar_guide/pages/ar_cam_page.dart';
import 'package:turismo_app/features/auth/presentation/pages/login_page.dart';
import 'package:turismo_app/features/auth/presentation/pages/register_page.dart';
import 'package:turismo_app/features/menu/presentation/menu_page.dart';
import 'package:turismo_app/features/user/presentation/pages/user_page.dart';

final appRouter = GoRouter(
  initialLocation: '/menu',
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

    // App
    ShellRoute(
      builder: (context, state, child) => AppPage(),
      routes: [
        GoRoute(
          path: '/menu',
          builder: (_, __) => const MenuPage(),
        ),
        GoRoute(
          path: '/ar',
          builder: (_, __) => const ArCamPage(),
        ),
        GoRoute(
          path: '/profile',
          builder: (_, __) => UserPage(),
        ),
      ],
    ),
  ],
);
