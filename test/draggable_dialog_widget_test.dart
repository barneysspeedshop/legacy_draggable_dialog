import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:legacy_draggable_dialog/draggable_dialog.dart';

void main() {
  group('DraggableDialog', () {
    testWidgets('renders body correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DraggableDialog(
                body: const Text('Dialog Body'), onDragUpdate: (_) {}),
          ),
        ),
      );

      expect(find.text('Dialog Body'), findsOneWidget);
    });

    testWidgets('renders header and footer when provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DraggableDialog(
                header: const Text('Header'),
                body: const Text('Body'),
                footer: const Text('Footer'),
                onDragUpdate: (_) {}),
          ),
        ),
      );

      expect(find.text('Header'), findsOneWidget);
      expect(find.text('Body'), findsOneWidget);
      expect(find.text('Footer'), findsOneWidget);
    });

    testWidgets('expands content when expandContent is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                SizedBox(
                  height: 500,
                  child: DraggableDialog(
                      body: const Text('Body'),
                      onDragUpdate: (_) {},
                      expandContent: true),
                ),
              ],
            ),
          ),
        ),
      );

      final bodyFinder = find
          .ancestor(of: find.text('Body'), matching: find.byType(Container))
          .first;

      // Check if the body container is wrapped in an Expanded widget
      // Note: This is a bit indirect. A better way is to check the size if possible,
      // but checking for Expanded ancestor in the widget tree is also valid for structure.
      expect(find.ancestor(of: bodyFinder, matching: find.byType(Expanded)),
          findsOneWidget);
    });

    testWidgets('does not expand content when expandContent is false',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                SizedBox(
                  height: 500,
                  child: DraggableDialog(
                      body: const Text('Body'),
                      onDragUpdate: (_) {},
                      expandContent: false),
                ),
              ],
            ),
          ),
        ),
      );

      final bodyFinder = find
          .ancestor(of: find.text('Body'), matching: find.byType(Container))
          .first;

      // Should not find Expanded ancestor directly wrapping the body container logic
      // This is tricky because Column/Row might use Expanded.
      // We rely on the implementation detail that _buildBody returns Expanded or Container.

      // Let's verify by size. If not expanded, it should be small.
      final Size bodySize = tester.getSize(bodyFinder);
      expect(bodySize.height,
          lessThan(400)); // Arbitrary check, assuming text is small
    });
  });
}
