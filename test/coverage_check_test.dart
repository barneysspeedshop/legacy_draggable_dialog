import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:legacy_draggable_dialog/legacy_draggable_dialog.dart';

void main() {
  testWidgets('verify assertion message at line 40', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  expect(
                    () => showLegacyDraggableDialog(context: context, body: const Text('Body'), barrierDismissible: false),
                    throwsA(isA<AssertionError>().having((e) => e.message, 'message', contains('The dialog must have a way to be closed'))),
                  );
                },
                child: const Text('Show Dialog'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show Dialog'));
  });

  testWidgets('barrierDismissible false with onClose works', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  showLegacyDraggableDialog(context: context, body: const Text('Body'), barrierDismissible: false, onClose: () {});
                },
                child: const Text('Show Dialog'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();
    expect(find.text('Body'), findsOneWidget);
  });
}
