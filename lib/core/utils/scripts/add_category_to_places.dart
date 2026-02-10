import 'package:cloud_firestore/cloud_firestore.dart';

/// Script de migración para agregar el campo 'category' a todos los lugares
/// EJECUTAR SOLO UNA VEZ
class AddCategoryToPlacesMigration {
  final FirebaseFirestore _firestore;

  AddCategoryToPlacesMigration({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Agrega el campo 'category' con valor por defecto a todos los lugares
  /// que no lo tengan
  Future<void> migrate({String defaultCategory = 'Sin categoría'}) async {
    print('🔄 Iniciando migración: Agregando campo category a lugares...');

    try {
      // Obtener todos los documentos de la colección 'places'
      final querySnapshot = await _firestore.collection('places').get();

      print('📊 Total de lugares encontrados: ${querySnapshot.docs.length}');

      int updated = 0;
      int skipped = 0;

      // Batch para optimizar las escrituras
      WriteBatch batch = _firestore.batch();
      int batchCount = 0;

      for (var doc in querySnapshot.docs) {
        final data = doc.data();

        // Solo actualizar si no tiene el campo 'category'
        if (!data.containsKey('category') || data['category'] == null) {
          batch.update(doc.reference, {'category': defaultCategory});
          updated++;
          batchCount++;

          print('  ✅ Actualizando: ${data['name']} -> category: $defaultCategory');

          // Firebase permite máximo 500 operaciones por batch
          if (batchCount >= 500) {
            await batch.commit();
            batch = _firestore.batch();
            batchCount = 0;
            print('  💾 Batch commit realizado (500 docs)');
          }
        } else {
          skipped++;
          print('  ⏭️  Saltando: ${data['name']} (ya tiene category: ${data['category']})');
        }
      }

      // Commit del batch restante
      if (batchCount > 0) {
        await batch.commit();
        print('  💾 Batch commit final realizado');
      }

      print('\n✅ Migración completada exitosamente!');
      print('📊 Resumen:');
      print('   - Lugares actualizados: $updated');
      print('   - Lugares saltados (ya tenían category): $skipped');
      print('   - Total procesado: ${querySnapshot.docs.length}');
      print('\n📝 Ahora puedes editar las categorías manualmente en Firebase Console.');
      print('   Categorías disponibles: Gastronomía, Cultura, Naturaleza, Hoteles, Aventura, Compras');

    } catch (e) {
      print('❌ Error durante la migración: $e');
      rethrow;
    }
  }

  /// Lista todos los lugares con sus categorías actuales
  Future<void> listPlacesWithCategories() async {
    print('📋 Listando lugares y sus categorías...\n');

    try {
      final querySnapshot = await _firestore.collection('places').get();

      final categoryCounts = <String, int>{};

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final name = data['name'] ?? 'Sin nombre';
        final category = data['category'] ?? 'SIN CATEGORY';

        categoryCounts[category] = (categoryCounts[category] ?? 0) + 1;

        print('  • $name -> $category');
      }

      print('\n📊 Resumen por categoría:');
      categoryCounts.forEach((category, count) {
        print('   - $category: $count lugar(es)');
      });

    } catch (e) {
      print('❌ Error listando lugares: $e');
    }
  }
}
