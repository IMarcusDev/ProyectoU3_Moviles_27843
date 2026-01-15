import 'package:flutter/material.dart';
import 'package:turismo_app/core/utils/theme/theme_colors.dart';

class TouristPlaceTile extends StatelessWidget {
  final String text;

  const TouristPlaceTile({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  text,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: ThemeColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Visto recientemente',
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
    );
  }
}
