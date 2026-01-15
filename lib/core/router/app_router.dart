
import 'package:go_router/go_router.dart';
import 'package:turismo_app/features/ar_guide/pages/ar_cam_page.dart';
import 'package:turismo_app/features/auth/presentation/pages/login_page.dart';
import 'package:turismo_app/features/auth/presentation/pages/register_page.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    // Auth
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => RegisterPage(),
    ),

    // AR
    GoRoute(
      path: '/ar',
      builder: (context, state) => const ArCamPage(),
    ),
  ],
);