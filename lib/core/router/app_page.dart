import 'package:flutter/material.dart';
import 'package:turismo_app/features/ar_guide/pages/ar_cam_page.dart';
import 'package:turismo_app/features/menu/presentation/pages/menu_page.dart';
import 'package:turismo_app/features/user/presentation/pages/user_page.dart';
import 'package:turismo_app/core/presentation/widgets/modern_bottom_nav_bar.dart';
import 'package:turismo_app/core/navigation/app_navigation.dart';

class AppPage extends StatefulWidget {
  const AppPage({super.key});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  late final PageController _pageController;
  int _currentIndex = 0;

  // Las 3 páginas principales de la app
  final List<Widget> _pages = [
    MenuPage(key: const ValueKey('menu')),
    const ArCamPage(key: ValueKey('ar')),
    UserPage(key: const ValueKey('profile')),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onNavBarTap(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppNavigation(
      controller: AppNavigationController(_pageController),
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          physics: const BouncingScrollPhysics(),
          children: _pages,
        ),
        bottomNavigationBar: ModernBottomNavBar(
          currentIndex: _currentIndex,
          onTap: _onNavBarTap,
        ),
      ),
    );
  }
}
