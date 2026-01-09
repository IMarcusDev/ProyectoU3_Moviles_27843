import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/tourist_place.dart';
import '../providers/map_providers.dart';

class PlaceDetailModal extends ConsumerWidget {
  final TouristPlace place;
  
  const PlaceDetailModal({super.key, required this.place});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  place.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Chip(
                label: Text(place.category),
                backgroundColor: Colors.indigo.shade50,
                labelStyle: const TextStyle(color: Colors.indigo),
              ),
            ],
          ),
          
          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 24),
              const SizedBox(width: 5),
              Text(
                place.rating.toStringAsFixed(1),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                " (${place.ratingCount} reseñas)",
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),

          const Divider(height: 30),

          Expanded(
            child: SingleChildScrollView(
              child: Text(
                place.description.isNotEmpty 
                    ? place.description 
                    : "Sin descripción disponible para este lugar.",
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.directions, color: Colors.white),
                  label: const Text("Ir Ahora", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              OutlinedButton.icon(
                onPressed: () => _showRatingDialog(context, ref),
                icon: const Icon(Icons.rate_review),
                label: const Text("Calificar"),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _showRatingDialog(BuildContext context, WidgetRef ref) {
    final commentController = TextEditingController();
    double selectedRating = 5.0;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Calificar Lugar"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("¿Qué te pareció tu visita?"),
                  const SizedBox(height: 15),
                  DropdownButton<double>(
                    value: selectedRating,
                    isExpanded: true,
                    items: [1, 2, 3, 4, 5].map((e) => DropdownMenuItem(
                      value: e.toDouble(),
                      child: Row(
                        children: [
                          Text("$e "),
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                        ],
                      ),
                    )).toList(),
                    onChanged: (val) => setState(() => selectedRating = val!),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: commentController,
                    decoration: const InputDecoration(
                      labelText: "Comentario",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await ref.read(touristRepositoryProvider).addReview(
                        place.id,
                        selectedRating,
                        commentController.text,
                      );
                      if (context.mounted) {
                        Navigator.pop(ctx);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("¡Gracias por tu reseña!")),
                        );
                        ref.refresh(allPlacesProvider);
                      }
                    } catch (e) {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
                      );
                    }
                  },
                  child: const Text("Enviar"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}