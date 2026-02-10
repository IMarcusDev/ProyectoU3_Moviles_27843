import 'package:flutter/material.dart';
import 'package:turismo_app/core/utils/theme/theme_colors.dart';
import 'package:turismo_app/core/domain/entities/rating.dart';

class PlaceRatingWidget extends StatefulWidget {
  final Function(int stars, String? comment) onSubmit;
  final Rating? existingRating;

  const PlaceRatingWidget({
    super.key,
    required this.onSubmit,
    this.existingRating,
  });

  @override
  State<PlaceRatingWidget> createState() => _PlaceRatingWidgetState();
}

class _PlaceRatingWidgetState extends State<PlaceRatingWidget> with SingleTickerProviderStateMixin {
  int _rating = 0;
  bool _isSubmitted = false;
  bool _showCommentField = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Pre-poblar con calificación existente si existe
    if (widget.existingRating != null) {
      _rating = widget.existingRating!.stars;
      if (widget.existingRating!.comment != null && widget.existingRating!.comment!.isNotEmpty) {
        _commentController.text = widget.existingRating!.comment!;
        _showCommentField = true;
      }
      _isSubmitted = true; // Mostrar como ya enviado
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _setRating(int value) {
    if (_isSubmitted) return;

    setState(() {
      _rating = value;
    });

    // Animación de feedback visual
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  Future<void> _handleSubmit() async {
    if (_rating == 0 || _isSubmitted) return;

    setState(() {
      _isSubmitted = true;
    });

    final comment = _commentController.text.trim();
    widget.onSubmit(_rating, comment.isEmpty ? null : comment);

    // Pequeño delay para mostrar el estado de éxito
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: _isSubmitted
          ? ThemeColors.primaryGreen.withValues(alpha: 0.2)
          : ThemeColors.primaryGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isSubmitted
            ? ThemeColors.primaryGreen
            : ThemeColors.primaryGreen.withValues(alpha: 0.3),
          width: _isSubmitted ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con ícono
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: ThemeColors.primaryGreen.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _isSubmitted ? Icons.check_circle_rounded : Icons.star_rounded,
                    color: ThemeColors.primaryGreen,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _isSubmitted
                      ? (widget.existingRating != null
                          ? 'Tu calificación'
                          : '¡Gracias por tu calificación!')
                      : '¿Visitaste esta zona? ¡Califícala!',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: ThemeColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),

            // Stars
            if (!_isSubmitted)
              ScaleTransition(
                scale: _scaleAnimation,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final starIndex = index + 1;
                    final isActive = starIndex <= _rating;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: InkWell(
                        onTap: () => _setRating(starIndex),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            isActive ? Icons.star_rounded : Icons.star_outline_rounded,
                            color: isActive
                                ? ThemeColors.primaryGreen
                                : ThemeColors.textSecondary,
                            size: 32,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

            // Rating text feedback
            if (_rating > 0 && !_isSubmitted)
              Center(
                child: Text(
                  _getRatingText(_rating),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: ThemeColors.textSecondary,
                  ),
                ),
              ),

            // Botón agregar comentario
            if (_rating > 0 && !_isSubmitted && !_showCommentField)
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _showCommentField = true;
                    });
                  },
                  icon: const Icon(
                    Icons.add_comment_outlined,
                    size: 16,
                  ),
                  label: const Text('Agregar comentario (opcional)'),
                  style: TextButton.styleFrom(
                    foregroundColor: ThemeColors.primaryGreen,
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

            // Campo de comentario
            if (_showCommentField && !_isSubmitted)
              TextField(
                controller: _commentController,
                maxLines: 3,
                maxLength: 200,
                decoration: InputDecoration(
                  hintText: 'Comparte tu experiencia...',
                  hintStyle: TextStyle(
                    fontSize: 13,
                    color: ThemeColors.textSecondary.withValues(alpha: 0.6),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: ThemeColors.primaryGreen.withValues(alpha: 0.3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: ThemeColors.primaryGreen.withValues(alpha: 0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: ThemeColors.primaryGreen,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
                style: const TextStyle(
                  fontSize: 13,
                  color: ThemeColors.textPrimary,
                ),
              ),

            // Success message con opción de editar
            if (_isSubmitted)
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: ThemeColors.primaryGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...List.generate(_rating, (index) =>
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2),
                            child: Icon(
                              Icons.star_rounded,
                              color: ThemeColors.primaryGreen,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$_rating de 5',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: ThemeColors.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.existingRating != null) ...[
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _isSubmitted = false;
                        });
                      },
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('Modificar calificación'),
                      style: TextButton.styleFrom(
                        foregroundColor: ThemeColors.primaryGreen,
                      ),
                    ),
                  ],
                ],
              ),

            // Submit button
            if (!_isSubmitted)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AnimatedOpacity(
                    opacity: _rating == 0 ? 0.5 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: Material(
                      color: _rating == 0
                        ? ThemeColors.textSecondary.withValues(alpha: 0.3)
                        : ThemeColors.primaryGreen,
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        onTap: _handleSubmit,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Enviar',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.send_rounded,
                                size: 16,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 1:
        return 'Muy insatisfecho';
      case 2:
        return 'Insatisfecho';
      case 3:
        return 'Aceptable';
      case 4:
        return 'Bueno';
      case 5:
        return '¡Excelente!';
      default:
        return '';
    }
  }
}
