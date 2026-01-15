import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:turismo_app/features/ar_guide/pages/ar_cam_page.dart';
import 'package:turismo_app/features/menu/presentation/menu_page.dart';
import 'package:turismo_app/features/user/presentation/pages/user_page.dart';

class AppPage extends StatefulWidget {
  const AppPage({super.key});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    MenuPage(),
    ArCamPage(),
    UserPage(),
  ];

  final List<String> _routes = ['/menu', '/ar', '/profile'];

  int _indexFromLocation(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final index = _routes.indexWhere((r) => location.startsWith(r));
    return index == -1 ? 0 : index;
  }

  void _onPageChanged(int index) {
    context.go(_routes[index]);
  }

  void _onTapNav(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _indexFromLocation(context);

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
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
