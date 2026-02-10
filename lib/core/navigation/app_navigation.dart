import 'package:flutter/material.dart';

/// Controlador de navegación interna de la app
class AppNavigationController {
  final PageController pageController;

  AppNavigationController(this.pageController);

  /// Navega a la página del menú (índice 0)
  void goToMenu() {
    pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
    );
  }

  /// Navega a la página del escáner AR (índice 1)
  void goToAR() {
    pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
    );
  }

  /// Navega a la página del perfil (índice 2)
  void goToProfile() {
    pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
    );
  }
}

/// InheritedWidget para acceder al controlador de navegación
class AppNavigation extends InheritedWidget {
  final AppNavigationController controller;

  const AppNavigation({
    super.key,
    required this.controller,
    required super.child,
  });

  static AppNavigationController of(BuildContext context) {
    final navigation = context.dependOnInheritedWidgetOfExactType<AppNavigation>();
    assert(navigation != null, 'No AppNavigation found in context');
    return navigation!.controller;
  }

  @override
  bool updateShouldNotify(AppNavigation oldWidget) => false;
}
