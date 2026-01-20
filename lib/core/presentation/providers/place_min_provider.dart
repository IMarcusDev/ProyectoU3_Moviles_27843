import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:turismo_app/core/data/repositories/place_min_repository_impl.dart';
import 'package:turismo_app/core/domain/entities/place_min.dart';
import 'package:turismo_app/core/domain/repositories/place_min_repository.dart';

final placeMinRepositoryProvider = Provider<PlaceMinRepository>((ref) {
  return PlaceMinRepositoryImpl();
});

class ViewedPlacesNotifier
    extends StateNotifier<AsyncValue<List<PlaceMin>>> {
  final PlaceMinRepository repository;

  ViewedPlacesNotifier(this.repository)
      : super(const AsyncValue.loading()) {
    loadPlaces();
  }

  Future<void> loadPlaces() async {
    try {
      final places = await repository.getAllViewedPlaces();
      state = AsyncValue.data(places);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addPlace(PlaceMin place) async {
    final current = state.value ?? [];

    try {
      final saved = await repository.addPlace(place);
      state = AsyncValue.data([...current, saved]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> clearAll() async {
    try {
      await repository.removeAllPlaces();
      state = const AsyncValue.data([]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final viewedPlacesProvider = StateNotifierProvider<
    ViewedPlacesNotifier, AsyncValue<List<PlaceMin>>>((ref) {
  final repository = ref.watch(placeMinRepositoryProvider);
  return ViewedPlacesNotifier(repository);
});
