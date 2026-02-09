import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turismo_app/core/presentation/widgets/place_rating_widget.dart';

void main() {
  group('PlaceRatingWidget', () {
    testWidgets('should render widget correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlaceRatingWidget(
              onSubmit: (rating) {},
            ),
          ),
        ),
      );

      expect(find.text('¿Visitaste esta zona? ¡Califícala!'), findsOneWidget);
      expect(find.byIcon(Icons.star_outline_rounded), findsNWidgets(5));
      expect(find.text('Enviar'), findsOneWidget);
    });

    testWidgets('should start with no rating selected', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlaceRatingWidget(
              onSubmit: (rating) {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.star_outline_rounded), findsNWidgets(5));
      expect(find.byIcon(Icons.star_rounded), findsNothing);
    });

    testWidgets('should update rating when star is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlaceRatingWidget(
              onSubmit: (rating) {},
            ),
          ),
        ),
      );

      // Tap on the third star
      final starButtons = find.byType(IconButton);
      await tester.tap(starButtons.at(2));
      await tester.pump();

      // Should have 3 filled stars and 2 outline stars
      expect(find.byIcon(Icons.star_rounded), findsNWidgets(3));
      expect(find.byIcon(Icons.star_outline_rounded), findsNWidgets(2));
    });

    testWidgets('should allow selecting all 5 stars', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlaceRatingWidget(
              onSubmit: (rating) {},
            ),
          ),
        ),
      );

      // Tap on the fifth star
      final starButtons = find.byType(IconButton);
      await tester.tap(starButtons.at(4));
      await tester.pump();

      expect(find.byIcon(Icons.star_rounded), findsNWidgets(5));
      expect(find.byIcon(Icons.star_outline_rounded), findsNothing);
    });

    testWidgets('should allow changing rating by tapping different star', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlaceRatingWidget(
              onSubmit: (rating) {},
            ),
          ),
        ),
      );

      final starButtons = find.byType(IconButton);

      // First tap on fourth star
      await tester.tap(starButtons.at(3));
      await tester.pump();

      expect(find.byIcon(Icons.star_rounded), findsNWidgets(4));

      // Then tap on second star
      await tester.tap(starButtons.at(1));
      await tester.pump();

      expect(find.byIcon(Icons.star_rounded), findsNWidgets(2));
      expect(find.byIcon(Icons.star_outline_rounded), findsNWidgets(3));
    });

    testWidgets('submit button should be disabled when no rating is selected', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlaceRatingWidget(
              onSubmit: (rating) {},
            ),
          ),
        ),
      );

      final submitButton = find.widgetWithText(TextButton, 'Enviar');
      final textButton = tester.widget<TextButton>(submitButton);

      expect(textButton.onPressed, isNull);
    });

    testWidgets('submit button should be enabled when rating is selected', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlaceRatingWidget(
              onSubmit: (rating) {},
            ),
          ),
        ),
      );

      // Tap on first star
      final starButtons = find.byType(IconButton);
      await tester.tap(starButtons.at(0));
      await tester.pump();

      final submitButton = find.widgetWithText(TextButton, 'Enviar');
      final textButton = tester.widget<TextButton>(submitButton);

      expect(textButton.onPressed, isNotNull);
    });

    testWidgets('should call onSubmit with correct rating when submit is pressed', (WidgetTester tester) async {
      int? submittedRating;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlaceRatingWidget(
              onSubmit: (rating) {
                submittedRating = rating;
              },
            ),
          ),
        ),
      );

      // Select 3 stars
      final starButtons = find.byType(IconButton);
      await tester.tap(starButtons.at(2));
      await tester.pump();

      // Tap submit button
      await tester.tap(find.text('Enviar'));
      await tester.pump();

      expect(submittedRating, 3);
    });

    testWidgets('should submit different ratings correctly', (WidgetTester tester) async {
      int? submittedRating;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlaceRatingWidget(
              onSubmit: (rating) {
                submittedRating = rating;
              },
            ),
          ),
        ),
      );

      final starButtons = find.byType(IconButton);

      // Test rating 1
      await tester.tap(starButtons.at(0));
      await tester.pump();
      await tester.tap(find.text('Enviar'));
      await tester.pump();
      expect(submittedRating, 1);

      // Test rating 5
      await tester.tap(starButtons.at(4));
      await tester.pump();
      await tester.tap(find.text('Enviar'));
      await tester.pump();
      expect(submittedRating, 5);
    });

    testWidgets('should have correct text styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlaceRatingWidget(
              onSubmit: (rating) {},
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
              onSubmit: (rating) {},
            ),
          ),
        ),
      );

      final container = find.byType(Container).first;
      final containerWidget = tester.widget<Container>(container);
      final decoration = containerWidget.decoration as BoxDecoration;

      expect(decoration.borderRadius, BorderRadius.circular(12));
      expect(decoration.boxShadow, isNotNull);
      expect(decoration.boxShadow!.length, 1);
    });

    testWidgets('should display all 5 star buttons', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlaceRatingWidget(
              onSubmit: (rating) {},
            ),
          ),
        ),
      );

      final iconButtons = find.byType(IconButton);
      // 5 star buttons
      expect(iconButtons, findsNWidgets(5));
    });

    testWidgets('should maintain state after multiple interactions', (WidgetTester tester) async {
      int? submittedRating;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlaceRatingWidget(
              onSubmit: (rating) {
                submittedRating = rating;
              },
            ),
          ),
        ),
      );

      final starButtons = find.byType(IconButton);

      // Tap multiple times
      await tester.tap(starButtons.at(4)); // 5 stars
      await tester.pump();
      await tester.tap(starButtons.at(2)); // 3 stars
      await tester.pump();
      await tester.tap(starButtons.at(3)); // 4 stars
      await tester.pump();

      expect(find.byIcon(Icons.star_rounded), findsNWidgets(4));

      await tester.tap(find.text('Enviar'));
      await tester.pump();

      expect(submittedRating, 4);
    });
  });
}
