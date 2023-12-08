import 'package:a8_bbyh/data/visits_repository.dart';
import 'package:a8_bbyh/models/visit.dart';
import 'package:a8_bbyh/widgets/home.dart';
import 'package:a8_bbyh/widgets/new_visit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class MockVisitsRepository implements IVisitsRepository {
  @override
  Future<List<Visit>> readVisits() async {
    return [
      Visit.withoutId(
          date: DateTime.now(),
          status: VisitStatus.approved,
          description: 'Visit 1'),
      Visit.withoutId(
          date: DateTime.now(),
          status: VisitStatus.pending,
          description: 'Visit 2'),
    ];
  }

  @override
  createVisit(Visit visit) {
    // Not necessary
  }

  @override
  deleteVisit(Visit visit) {
    // Not necessary
  }

  @override
  updateVisit(Visit visit) {
    // Not necessary
  }
}

void main() {
  group('HomePage Widget Tests', () {
    testWidgets('Renders HomePage with data', (WidgetTester tester) async {
      // Build HomePage
      await tester.pumpWidget(
        MaterialApp(
          home: HomePage(
            title: 'Test Title',
            visitsRepo: MockVisitsRepository(),
          ),
        ),
      );

      // Assert that the title is correctly set and the loading spinner is shown.
      expect(find.text('Test Title'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for the spinner to disappear
      await tester.pumpAndSettle();

      // Assert that the spinner is gone and there are two Visits in the list.
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(ListTile), findsNWidgets(2));
    });

    testWidgets('Tapping the "+" button navigates to NewVisit page',
        (WidgetTester tester) async {
      // Build HomePage
      await tester.pumpWidget(
        MaterialApp(
          home: HomePage(
            title: 'Test Title',
            visitsRepo: MockVisitsRepository(),
          ),
        ),
      );

      // Tap the "+" button and wait for the NewVisit screen to appear.
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Assert that the NewVisit screen is shown
      expect(find.byType(NewVisit), findsOneWidget);
    });
  });
}
