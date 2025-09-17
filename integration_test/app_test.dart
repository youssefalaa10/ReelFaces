import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:reelfaces/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('ReelFaces App Integration Tests', () {
    testWidgets('should launch app and show main screen', (
      WidgetTester tester,
    ) async {
      // Act - Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Assert - Verify the main screen loads
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should display ListView for people', (
      WidgetTester tester,
    ) async {
      // Act - Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Wait a bit for the app to load data
      await tester.pump(const Duration(seconds: 2));

      // Assert - Verify ListView is present
      expect(find.byType(ListView), findsWidgets);
      expect(find.byType(CustomScrollView), findsWidgets);
    });

    testWidgets('should show welcome message', (WidgetTester tester) async {
      // Act - Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Wait for content to load
      await tester.pump(const Duration(seconds: 2));

      // Assert - Verify welcome message is displayed
      // Note: This will depend on your AppStrings.welcomeMessage content
      expect(find.text('Welcome'), findsWidgets);
    });

    testWidgets('should have proper app structure', (
      WidgetTester tester,
    ) async {
      // Act - Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Assert - Verify basic app structure
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SafeArea), findsOneWidget);
    });
  });
}
