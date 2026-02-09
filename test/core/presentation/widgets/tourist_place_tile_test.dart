import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turismo_app/core/domain/entities/place_min.dart';
import 'package:turismo_app/core/presentation/widgets/tourist_place_tile.dart';

void main() {
  group('TouristPlaceTile', () {
    testWidgets('should render tile with place name', (WidgetTester tester) async {
      final place = PlaceMin(
        id: '1',
        name: 'Beautiful Beach',
        lastScanned: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TouristPlaceTile(place: place),
          ),
        ),
      );

      expect(find.text('Beautiful Beach'), findsOneWidget);
    });

    testWidgets('should display place icon', (WidgetTester tester) async {
      final place = PlaceMin(
        id: '1',
        name: 'Test Place',
        lastScanned: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TouristPlaceTile(place: place),
          ),
        ),
      );

      expect(find.byIcon(Icons.place_outlined), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('should display chevron right icon', (WidgetTester tester) async {
      final place = PlaceMin(
        id: '1',
        name: 'Test Place',
        lastScanned: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TouristPlaceTile(place: place),
          ),
        ),
      );

      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('should show "Visto recientemente" for places scanned less than 1 minute ago', (WidgetTester tester) async {
      final place = PlaceMin(
        id: '1',
        name: 'Recent Place',
        lastScanned: DateTime.now().subtract(Duration(seconds: 30)),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TouristPlaceTile(place: place),
          ),
        ),
      );

      expect(find.text('Visto recientemente'), findsOneWidget);
    });

    testWidgets('should show minutes ago for places scanned less than 1 hour ago', (WidgetTester tester) async {
      final place = PlaceMin(
        id: '1',
        name: 'Place',
        lastScanned: DateTime.now().subtract(Duration(minutes: 30)),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TouristPlaceTile(place: place),
          ),
        ),
      );

      expect(find.textContaining('Visto hace'), findsOneWidget);
      expect(find.textContaining('minuto'), findsOneWidget);
    });

    testWidgets('should use singular form for 1 minute', (WidgetTester tester) async {
      final place = PlaceMin(
        id: '1',
        name: 'Place',
        lastScanned: DateTime.now().subtract(Duration(minutes: 1)),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TouristPlaceTile(place: place),
          ),
        ),
      );

      expect(find.text('Visto hace 1 minuto'), findsOneWidget);
    });

    testWidgets('should show hours ago for places scanned less than 24 hours ago', (WidgetTester tester) async {
      final place = PlaceMin(
        id: '1',
        name: 'Place',
        lastScanned: DateTime.now().subtract(Duration(hours: 5)),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TouristPlaceTile(place: place),
          ),
        ),
      );

      expect(find.textContaining('Visto hace'), findsOneWidget);
      expect(find.textContaining('hora'), findsOneWidget);
    });

    testWidgets('should use singular form for 1 hour', (WidgetTester tester) async {
      final place = PlaceMin(
        id: '1',
        name: 'Place',
        lastScanned: DateTime.now().subtract(Duration(hours: 1)),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TouristPlaceTile(place: place),
          ),
        ),
      );

      expect(find.text('Visto hace 1 hora'), findsOneWidget);
    });

    testWidgets('should show days ago for places scanned less than 7 days ago', (WidgetTester tester) async {
      final place = PlaceMin(
        id: '1',
        name: 'Place',
        lastScanned: DateTime.now().subtract(Duration(days: 3)),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TouristPlaceTile(place: place),
          ),
        ),
      );

      expect(find.textContaining('Visto hace'), findsOneWidget);
      expect(find.textContaining('día'), findsOneWidget);
    });

    testWidgets('should use singular form for 1 day', (WidgetTester tester) async {
      final place = PlaceMin(
        id: '1',
        name: 'Place',
        lastScanned: DateTime.now().subtract(Duration(days: 1)),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TouristPlaceTile(place: place),
          ),
        ),
      );

      expect(find.text('Visto hace 1 día'), findsOneWidget);
    });

    testWidgets('should show formatted date for places scanned more than 7 days ago', (WidgetTester tester) async {
      final lastScanned = DateTime(2024, 1, 15, 10, 30);
      final place = PlaceMin(
        id: '1',
        name: 'Old Place',
        lastScanned: lastScanned,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TouristPlaceTile(place: place),
          ),
        ),
      );

      expect(find.text('Visto el 15/1/2024'), findsOneWidget);
    });

    testWidgets('should call onTap when tile is tapped', (WidgetTester tester) async {
      bool wasTapped = false;
      final place = PlaceMin(
        id: '1',
        name: 'Tappable Place',
        lastScanned: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TouristPlaceTile(
              place: place,
              onTap: () {
                wasTapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pump();

      expect(wasTapped, true);
    });

    testWidgets('should not crash when onTap is null', (WidgetTester tester) async {
      final place = PlaceMin(
        id: '1',
        name: 'Place',
        lastScanned: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TouristPlaceTile(place: place),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pump();

      // Should not throw any errors
    });

    testWidgets('should have proper styling and layout', (WidgetTester tester) async {
      final place = PlaceMin(
        id: '1',
        name: 'Styled Place',
        lastScanned: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TouristPlaceTile(place: place),
          ),
        ),
      );

      // Check for Material widget
      expect(find.byType(Material), findsWidgets);

      // Check for InkWell (for tap effect)
      expect(find.byType(InkWell), findsOneWidget);

      // Check for Row layout
      expect(find.byType(Row), findsOneWidget);

      // Check for CircleAvatar
      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('should use Column for text layout', (WidgetTester tester) async {
      final place = PlaceMin(
        id: '1',
        name: 'Test Place',
        lastScanned: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TouristPlaceTile(place: place),
          ),
        ),
      );

      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('should display different places differently', (WidgetTester tester) async {
      final place1 = PlaceMin(
        id: '1',
        name: 'First Place',
        lastScanned: DateTime.now().subtract(Duration(minutes: 5)),
      );

      final place2 = PlaceMin(
        id: '2',
        name: 'Second Place',
        lastScanned: DateTime.now().subtract(Duration(days: 10)),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                TouristPlaceTile(place: place1),
                TouristPlaceTile(place: place2),
              ],
            ),
          ),
        ),
      );

      expect(find.text('First Place'), findsOneWidget);
      expect(find.text('Second Place'), findsOneWidget);
      expect(find.textContaining('Visto hace'), findsOneWidget);
      expect(find.textContaining('Visto el'), findsOneWidget);
    });

    testWidgets('should have rounded corners', (WidgetTester tester) async {
      final place = PlaceMin(
        id: '1',
        name: 'Place',
        lastScanned: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TouristPlaceTile(place: place),
          ),
        ),
      );

      final inkWell = tester.widget<InkWell>(find.byType(InkWell));
      expect(inkWell.borderRadius, BorderRadius.circular(16));
    });
  });
}
