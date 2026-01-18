import 'package:flutter/material.dart';
import 'package:turismo_app/core/utils/theme/theme_colors.dart';
import 'package:turismo_app/features/menu/domain/entities/place_min.dart';

class TouristPlaceTile extends StatelessWidget {
  final PlaceMin place;
  final VoidCallback? onTap;

  const TouristPlaceTile({
    super.key,
    required this.place,
    this.onTap,
  });

  String formatLastScanned(DateTime lastScanned) {
    final now = DateTime.now();
    final diff = now.difference(lastScanned);

    if (diff.inMinutes < 1) {
      return 'Visto recientemente';
    } else if (diff.inMinutes < 60) {
      return 'Visto hace ${diff.inMinutes} minuto${diff.inMinutes == 1 ? '' : 's'}';
    } else if (diff.inHours < 24) {
      return 'Visto hace ${diff.inHours} hora${diff.inHours == 1 ? '' : 's'}';
    } else if (diff.inDays < 7) {
      return 'Visto hace ${diff.inDays} día${diff.inDays == 1 ? '' : 's'}';
    } else {
      return 'Visto el ${_formatDate(lastScanned)}';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor:
                    ThemeColors.primaryGreen.withOpacity(0.15),
                child: Icon(
                  Icons.place_outlined,
                  color: ThemeColors.primaryGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: ThemeColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatLastScanned(place.lastScanned),
                      style: TextStyle(
                        fontSize: 12,
                        color: ThemeColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
