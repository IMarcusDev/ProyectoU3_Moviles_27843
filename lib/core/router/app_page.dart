import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:turismo_app/features/ar_guide/pages/ar_cam_page.dart';
import 'package:turismo_app/features/menu/presentation/pages/menu_page.dart';
import 'package:turismo_app/features/user/presentation/pages/user_page.dart';

class AppPage extends StatefulWidget {
  const AppPage({super.key});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  final PageController _controller = PageController();

  final _pages = [
    MenuPage(),
    ArCamPage(),
    UserPage(),
  ];

  final _routes = ['/menu', '/ar', '/profile'];

  int _indexFromLocation(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final index = _routes.indexWhere((r) => location.startsWith(r));
    return index == -1 ? 0 : index;
  }

  void _onPageChanged(int index) {
    context.go(_routes[index]);
  }

  void _onTapNav(int index) {
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _indexFromLocation(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.hasClients &&
          _controller.page?.round() != currentIndex) {
        _controller.jumpToPage(currentIndex);
      }
    });

    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: _onPageChanged,
        physics: const BouncingScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: _onTapNav,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Menú',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_in_ar),
            label: 'AR',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
