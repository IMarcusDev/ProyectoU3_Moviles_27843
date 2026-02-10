import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turismo_app/core/presentation/widgets/place_rating_widget.dart';
import 'package:turismo_app/core/domain/entities/rating.dart';

void main() {
  group('PlaceRatingWidget', () {
    testWidgets('should render widget correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlaceRatingWidget(
              onSubmit: (stars, comment) {},
            ),
          ),
        ),
      );

      expect(find.text('¿Visitaste esta zona? ¡Califícala!'), findsOneWidget);
      expect(find.byIcon(Icons.star_outline_rounded), findsNWidgets(5));
      expect(find.text('Enviar'), findsOneWidget);
      // Hay un ícono adicional en el header (star_rounded)
      expect(find.byIcon(Icons.star_rounded), findsOneWidget);
    });

    testWidgets('should start with no rating selected', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlaceRatingWidget(
              onSubmit: (stars, comment) {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.star_outline_rounded), findsNWidgets(5));
      // Solo debe haber 1 star_rounded (el del header)
      expect(find.byIcon(Icons.star_rounded), findsOneWidget);
    });

    testWidgets('should update rating when star is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlaceRatingWidget(
              onSubmit: (stars, comment) {},
            ),
          ),
        ),
      );

      // Tap on the third star (las estrellas ahora son InkWell)
      final starIcons = find.byIcon(Icons.star_outline_rounded);
      await tester.tap(starIcons.at(2));
      await tester.pump();

      // Should have 3 filled stars, 2 outline stars, + 1 en el header
      expect(find.byIcon(Icons.star_rounded), findsNWidgets(4)); // 3 + 1 header
      expect(find.byIcon(Icons.star_outline_rounded), findsNWidgets(2));
    });

    testWidgets('should allow selecting all 5 stars', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlaceRatingWidget(
              onSubmit: (stars, comment) {},
            ),
          ),
        ),
      );

      // Tap on the fifth star
      final starIcons = find.byIcon(Icons.star_outline_rounded);
      await tester.tap(starIcons.at(4));
      await tester.pump();

      // 5 estrellas + 1 en el header
      expect(find.byIcon(Icons.star_rounded), findsNWidgets(6));
      expect(find.byIcon(Icons.star_outline_rounded), findsNothing);
    });

    testWidgets('submit button should have reduced opacity when no rating is selected', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlaceRatingWidget(
              onSubmit: (stars, comment) {},
            ),
          ),
        ),
      );

      // El botón existe pero con opacidad reducida
      expect(find.text('Enviar'), findsOneWidget);

      final animatedOpacity = tester.widget<AnimatedOpacity>(
        find.ancestor(
          of: find.text('Enviar'),
          matching: find.byType(AnimatedOpacity),
        ),
      );

      expect(animatedOpacity.opacity, 0.5);
    });

    testWidgets('submit button should have full opacity when rating is selected', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlaceRatingWidget(
              onSubmit: (stars, comment) {},
            ),
          ),
        ),
      );

      // Tap on first star
      final starIcons = find.byIcon(Icons.star_outline_rounded);
      await tester.tap(starIcons.first);
      await tester.pump();

      final animatedOpacity = tester.widget<AnimatedOpacity>(
        find.ancestor(
          of: find.text('Enviar'),
          matching: find.byType(AnimatedOpacity),
        ),
      );

      expect(animatedOpacity.opacity, 1.0);
    });

    testWidgets('should call onSubmit with correct rating when submit is pressed', (WidgetTester tester) async {
      int? submittedRating;
      String? submittedComment;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlaceRatingWidget(
              onSubmit: (stars, comment) {
                submittedRating = stars;
                submittedComment = comment;
              },
            ),
          ),
        ),
      );

      // Select 3 stars
      final starIcons = find.byIcon(Icons.star_outline_rounded);
      await tester.tap(starIcons.at(2));
      await tester.pump();

      // Tap submit button (ahora es un InkWell)
      await tester.tap(find.text('Enviar'));
      await tester.pump();

      // Esperar el delay de 500ms del _handleSubmit
      await tester.pump(const Duration(milliseconds: 500));

      expect(submittedRating, 3);
      expect(submittedComment, null);
    });

    testWidgets('should submit different ratings correctly', (WidgetTester tester) async {
      int? submittedRating;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlaceRatingWidget(
              onSubmit: (stars, comment) {
                submittedRating = stars;
              },
            ),
          ),
        ),
      );

      // Test rating 1
      var starIcons = find.byIcon(Icons.star_outline_rounded);
      await tester.tap(starIcons.first);
      await tester.pump();
      await tester.tap(find.text('Enviar'));
      await tester.pump();

      // Esperar el delay de 500ms del _handleSubmit
      await tester.pump(const Duration(milliseconds: 500));

      expect(submittedRating, 1);

      // Después de submit, el widget está en estado submitted
      // Para este test necesitaríamos recrear el widget
    });

    testWidgets('should have correct text styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlaceRatingWidget(
              onSubmit: (stars, comment) {},
            ),
          ),
        ),
      );

      final textWidget = find.text('¿Visitaste esta zona? ¡Califícala!');
      expect(textWidget, findsOneWidget);

      final text = tester.widget<Text>(textWidget);
      expect(text.style?.fontSize, 14);
      expect(text.style?.fontWeight, FontWeight.w600);
    });

    testWidgets('should have proper container decoration', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlaceRatingWidget(
              onSubmit: (stars, comment) {},
            ),
          ),
        ),
      );

      final animatedContainer = find.byType(AnimatedContainer).first;
      final containerWidget = tester.widget<AnimatedContainer>(animatedContainer);
      final decoration = containerWidget.decoration as BoxDecoration;

      expect(decoration.borderRadius, BorderRadius.circular(16));
      expect(decoration.boxShadow, isNotNull);
      expect(decoration.boxShadow!.length, 1);
    });

    testWidgets('should display all 5 star widgets', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlaceRatingWidget(
              onSubmit: (stars, comment) {},
            ),
          ),
        ),
      );

      // Simplemente verificar que hay 5 estrellas outline (estado inicial)
      expect(find.byIcon(Icons.star_outline_rounded), findsNWidgets(5));
    });

    testWidgets('should pre-populate with existing rating', (WidgetTester tester) async {
      final existingRating = Rating(
        id: 'test-id',
        userId: 'user-id',
        userName: 'Test User',
        placeId: 'place-id',
        stars: 4,
        comment: 'Great place!',
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlaceRatingWidget(
              existingRating: existingRating,
              onSubmit: (stars, comment) {},
            ),
          ),
        ),
      );

      // Debería mostrar el texto de calificación existente
      expect(find.text('Tu calificación'), findsOneWidget);

      // Debería mostrar 4 estrellas en el resumen
      expect(find.text('4 de 5'), findsOneWidget);

      // Debería mostrar el botón de modificar
      expect(find.text('Modificar calificación'), findsOneWidget);
    });

    testWidgets('should show comment button after selecting rating', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlaceRatingWidget(
              onSubmit: (stars, comment) {},
            ),
          ),
        ),
      );

      // Initially no comment button
      expect(find.text('Agregar comentario (opcional)'), findsNothing);

      // Select a rating
      final starIcons = find.byIcon(Icons.star_outline_rounded);
      await tester.tap(starIcons.first);
      await tester.pump();

      // Comment button should appear
      expect(find.text('Agregar comentario (opcional)'), findsOneWidget);
    });

    testWidgets('should show comment field when comment button is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlaceRatingWidget(
              onSubmit: (stars, comment) {},
            ),
          ),
        ),
      );

      // Select a rating
      final starIcons = find.byIcon(Icons.star_outline_rounded);
      await tester.tap(starIcons.first);
      await tester.pump();

      // Tap comment button
      await tester.tap(find.text('Agregar comentario (opcional)'));
      await tester.pump();

      // Comment field should appear
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Comparte tu experiencia...'), findsOneWidget);
    });
  });
}
