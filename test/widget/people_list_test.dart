import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reelfaces/core/domain/entities/person.dart';
import 'package:reelfaces/core/widgets/person_card.dart';

void main() {
  group('PeopleList Widget Tests', () {
    testWidgets('should display person names in the list', (
      WidgetTester tester,
    ) async {
      final dummyPeople = [
        const Person(
          id: 1,
          name: 'Youssef Alaa',
          adult: true,
          knownFor: [1, 2, 3],
          profilePath: '/path/to/john.jpg',
          popularity: 85.5,
        ),
        const Person(
          id: 2,
          name: 'Saif',
          adult: true,
          knownFor: [4, 5],
          profilePath: '/path/to/jane.jpg',
          popularity: 92.0,
        ),
        const Person(
          id: 3,
          name: 'Mahmoud Ali',
          adult: false,
          knownFor: [6],
          profilePath: '/path/to/bob.jpg',
          popularity: 78.3,
        ),
      ];

      // Act
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, child) {
            return MaterialApp(
              home: Scaffold(
                body: ListView.builder(
                  itemCount: dummyPeople.length,
                  itemBuilder: (context, index) {
                    final person = dummyPeople[index];
                    return PersonCard(person: person, onTap: () {});
                  },
                ),
              ),
            );
          },
        ),
      );

      // Assert
      expect(find.text('Youssef Alaa'), findsOneWidget);
      expect(find.text('Saif'), findsOneWidget);
      expect(find.text('Mahmoud Ali'), findsOneWidget);
    });

    testWidgets('should display correct number of people', (
      WidgetTester tester,
    ) async {
      // Arrange - Create dummy people data
      final dummyPeople = [
        const Person(id: 1, name: 'Person 1', adult: true, knownFor: []),
        const Person(id: 2, name: 'Person 2', adult: true, knownFor: []),
        const Person(id: 3, name: 'Person 3', adult: true, knownFor: []),
      ];

      // Act - Build the widget
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, child) {
            return MaterialApp(
              home: Scaffold(
                body: ListView.builder(
                  itemCount: dummyPeople.length,
                  itemBuilder: (context, index) {
                    final person = dummyPeople[index];
                    return PersonCard(person: person, onTap: () {});
                  },
                ),
              ),
            );
          },
        ),
      );

      // Assert - Verify correct number of items
      expect(find.byType(PersonCard), findsNWidgets(3));
    });

    testWidgets('should handle empty list gracefully', (
      WidgetTester tester,
    ) async {
      // Arrange - Empty list
      final emptyPeople = <Person>[];

      // Act - Build the widget with empty list
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, child) {
            return MaterialApp(
              home: Scaffold(
                body: ListView.builder(
                  itemCount: emptyPeople.length,
                  itemBuilder: (context, index) {
                    final person = emptyPeople[index];
                    return PersonCard(person: person, onTap: () {});
                  },
                ),
              ),
            );
          },
        ),
      );

      // Assert - Verify no person cards are displayed
      expect(find.byType(PersonCard), findsNothing);
    });
  });
}
