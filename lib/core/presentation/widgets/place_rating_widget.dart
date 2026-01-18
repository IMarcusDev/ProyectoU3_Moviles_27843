import 'package:flutter/material.dart';
import 'package:turismo_app/core/utils/theme/theme_colors.dart';

class PlaceRatingWidget extends StatefulWidget {
  final ValueChanged<int>? onRatingChanged;

  const PlaceRatingWidget({
    super.key,
    this.onRatingChanged,
  });

  @override
  State<PlaceRatingWidget> createState() => _PlaceRatingWidgetState();
}

class _PlaceRatingWidgetState extends State<PlaceRatingWidget> {
  int _rating = 0;

  void _setRating(int value) {
    setState(() {
      _rating = value;
    });

    widget.onRatingChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.primaryGreen.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsetsGeometry.all(12),
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¿Visitaste esta zona? ¡Califícala!',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: ThemeColors.textPrimary,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final starIndex = index + 1;
                final isActive = starIndex <= _rating;

                return IconButton(
                  onPressed: () => _setRating(starIndex),
                  icon: Icon(
                    isActive ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: isActive
                        ? ThemeColors.primaryGreen
                        : ThemeColors.textSecondary,
                    size: 28,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashRadius: 20,
                );
              }),
            ),

            // Send Data
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _rating == 0
                    ? null
                    : () {
                        print(_rating);
                      },
                  style: TextButton.styleFrom(
                    padding: EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Enviar',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: ThemeColors.primaryGreen,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}
