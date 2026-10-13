import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:legacy_draggable_dialog/legacy_draggable_dialog.dart';

void main() {
  testWidgets('showLegacyDraggableDialog shows a dialog',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  showLegacyDraggableDialog(
                    context: context,
                    title: 'Test Dialog',
                    body: const Text('Hello World'),
                    onClose: () => Navigator.of(context).pop(),
                  );
                },
                child: const Text('Show Dialog'),
              );
            },
          ),
        ),
      ),
    );

    // Verify dialog is not visible initially
    expect(find.text('Test Dialog'), findsNothing);

    // Tap the button to show the dialog
    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();

    // Verify dialog is visible
    expect(find.text('Test Dialog'), findsOneWidget);
    expect(find.text('Hello World'), findsOneWidget);

    // Close the dialog
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    // Verify dialog is closed
    expect(find.text('Test Dialog'), findsNothing);
  });

  testWidgets('throws assertion error if no close mechanism provided',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  expect(
                    () => showLegacyDraggableDialog(
                      context: context,
                      body: const Text('Body'),
                      barrierDismissible: false,
                      // No onClose, onOk, onCancel, header, footer, or actions
                    ),
                    throwsAssertionError,
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

  testWidgets('renders actions correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  showLegacyDraggableDialog(
                    context: context,
                    body: const Text('Body'),
                    actions: [
                      TextButton(
                          onPressed: () {}, child: const Text('Action 1')),
                      TextButton(
                          onPressed: () {}, child: const Text('Action 2')),
                    ],
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
    await tester.pumpAndSettle();

    expect(find.text('Action 1'), findsOneWidget);
    expect(find.text('Action 2'), findsOneWidget);
  });

  testWidgets('footer overrides actions', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  showLegacyDraggableDialog(
                    context: context,
                    body: const Text('Body'),
                    footer: const Text('Custom Footer'),
                    actions: [
                      TextButton(
                          onPressed: () {}, child: const Text('Action 1'))
                    ],
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
    await tester.pumpAndSettle();

    expect(find.text('Custom Footer'), findsOneWidget);
    expect(find.text('Action 1'), findsNothing);
  });

  testWidgets('renders onOk and onCancel buttons', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  showLegacyDraggableDialog(
                      context: context,
                      body: const Text('Body'),
                      onOk: () {},
                      onCancel: () {},
                      okText: 'Yes',
                      cancelText: 'No');
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

    expect(find.text('Yes'), findsOneWidget);
    expect(find.text('No'), findsOneWidget);
  });
  testWidgets('dialog moves when header is dragged',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  showLegacyDraggableDialog(
                    context: context,
                    title: 'Draggable Dialog',
                    body: const Text('Content'),
                    // We need a close mechanism to avoid assertion error, or barrierDismissible (default true)
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
    await tester.pumpAndSettle();

    final title = find.text('Draggable Dialog');
    final before = tester.getCenter(title);

    await tester.drag(title, const Offset(200, 200));
    await tester.pump();

    final after = tester.getCenter(title);
    expect(after.dx, greaterThan(before.dx));
    expect(after.dy, greaterThan(before.dy));
  });
  testWidgets('dialog does not move when size equals screen size',
      (WidgetTester tester) async {
    // Reset and set a fixed screen size
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
    tester.view.physicalSize = const Size(800, 600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  showLegacyDraggableDialog(
                    context: context,
                    title: 'Full Screen Dialog',
                    body: const Text('Content'),
                    width: 800,
                    height: 600,
                    // We need a close mechanism to avoid assertion error, or barrierDismissible (default true)
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
    await tester.pumpAndSettle();

    final title = find.text('Full Screen Dialog');
    final before = tester.getCenter(title);

    await tester.drag(title, const Offset(200, 200));
    await tester.pump();

    expect(tester.getCenter(title), before);
  });
}
