/// Sistema de espaciado consistente basado en 8dp grid
/// Usar estos valores en toda la aplicación para mantener consistencia
class AppSpacing {
  // Espaciados base (múltiplos de 8)
  static const double xs = 4.0;    // Extra small - 0.5x
  static const double sm = 8.0;    // Small - 1x
  static const double md = 12.0;   // Medium - 1.5x
  static const double lg = 16.0;   // Large - 2x
  static const double xl = 24.0;   // Extra large - 3x
  static const double xxl = 32.0;  // Extra extra large - 4x
  static const double xxxl = 48.0; // Triple extra large - 6x

  // Padding de página estándar
  static const double pagePadding = lg; // 16

  // Padding de tarjetas
  static const double cardPadding = lg; // 16
  static const double cardPaddingSmall = md; // 12

  // Separación entre elementos
  static const double listItemSpacing = md; // 12
  static const double sectionSpacing = xl; // 24
  static const double componentSpacing = sm; // 8

  // Border radius estándar
  static const double radiusSmall = sm; // 8
  static const double radiusMedium = md; // 12
  static const double radiusLarge = lg; // 16
  static const double radiusXLarge = xl; // 24

  // Tamaños de botones
  static const double buttonHeightSmall = 36.0;
  static const double buttonHeight = 48.0;
  static const double buttonHeightLarge = 56.0;

  // Tamaños de íconos
  static const double iconSmall = 20.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
  static const double iconXLarge = 48.0;

  AppSpacing._(); // Prevent instantiation
}
