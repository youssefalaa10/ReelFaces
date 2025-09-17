import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Simple Widget Tests', () {
    testWidgets('should display person names in a simple list', (
      WidgetTester tester,
    ) async {
      final dummyPeople = ['Youssef Alaa', 'Saif', 'Mahmoud Ali'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView.builder(
              itemCount: dummyPeople.length,
              itemBuilder: (context, index) {
                return ListTile(title: Text(dummyPeople[index]));
              },
            ),
          ),
        ),
      );

      expect(find.text('Youssef Alaa'), findsOneWidget);
      expect(find.text('Saif'), findsOneWidget);
      expect(find.text('Mahmoud Ali'), findsOneWidget);
    });

    testWidgets('should display correct number of people', (
      WidgetTester tester,
    ) async {
      final dummyPeople = ['Person 1', 'Person 2', 'Person 3'];

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView.builder(
              itemCount: dummyPeople.length,
              itemBuilder: (context, index) {
                return ListTile(title: Text(dummyPeople[index]));
              },
            ),
          ),
        ),
      );

      // Assert - Verify correct number of items
      expect(find.byType(ListTile), findsNWidgets(3));
    });

    testWidgets('should handle empty list gracefully', (
      WidgetTester tester,
    ) async {
      final emptyPeople = <String>[];

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView.builder(
              itemCount: emptyPeople.length,
              itemBuilder: (context, index) {
                return ListTile(title: Text(emptyPeople[index]));
              },
            ),
          ),
        ),
      );

      expect(find.byType(ListTile), findsNothing);
    });
  });
}
