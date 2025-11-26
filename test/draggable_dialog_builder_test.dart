import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:legacy_draggable_dialog/legacy_draggable_dialog.dart';

void main() {
  testWidgets('showDraggableDialogWithBuilder renders content',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  showDraggableDialogWithBuilder(
                    context: context,
                    builder: (context, onDragUpdate) {
                      return Container(
                          color: Colors.white,
                          child: const Text('Builder Content'));
                    },
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

    expect(find.text('Builder Content'), findsOneWidget);
  });

  testWidgets('dragging moves the dialog', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  showDraggableDialogWithBuilder(
                    context: context,
                    builder: (context, onDragUpdate) {
                      return GestureDetector(
                        onPanUpdate: onDragUpdate,
                        child: Container(
                            width: 200,
                            height: 200,
                            color: Colors.blue,
                            child: const Text('Drag Me')),
                      );
                    },
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

    final dialogFinder = find.text('Drag Me');
    final initialLocation = tester.getCenter(dialogFinder);

    // Drag the dialog
    await tester.drag(dialogFinder, const Offset(100, 100));
    await tester.pump();

    final newLocation = tester.getCenter(dialogFinder);

    expect(newLocation, isNot(equals(initialLocation)));
    // We expect it to move down and right
    expect(newLocation.dx, greaterThan(initialLocation.dx));
    expect(newLocation.dy, greaterThan(initialLocation.dy));
  });

  testWidgets(
      'dragging does not move dialog if width/height equals screen size',
      (WidgetTester tester) async {
    // Set a fixed screen size for the test
    tester.view.physicalSize = const Size(800, 600);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  showDraggableDialogWithBuilder(
                    context: context,
                    width: 800, // Matches screen width
                    height: 600, // Matches screen height
                    builder: (context, onDragUpdate) {
                      return GestureDetector(
                        onPanUpdate: onDragUpdate,
                        child: Container(
                            color: Colors.red,
                            child: const Text('Full Screen Drag')),
                      );
                    },
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

    final dialogFinder = find.text('Full Screen Drag');
    final initialLocation = tester.getCenter(dialogFinder);

    // Try to drag
    await tester.drag(dialogFinder, const Offset(100, 100));
    await tester.pump();

    final newLocation = tester.getCenter(dialogFinder);

    // Should not move
    expect(newLocation, equals(initialLocation));

    // Reset window size
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  });

  testWidgets('dragging clamps to screen boundaries',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 600);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  showDraggableDialogWithBuilder(
                    context: context,
                    width: 400,
                    height: 300,
                    builder: (context, onDragUpdate) {
                      return GestureDetector(
                        onPanUpdate: onDragUpdate,
                        child: Container(
                            color: Colors.green,
                            child: const Text('Clamp Drag')),
                      );
                    },
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

    final dialogFinder = find.text('Clamp Drag');

    // Drag way off screen to the right and bottom
    await tester.drag(dialogFinder, const Offset(1000, 1000));
    await tester.pump();

    final centerAfterFirstDrag = tester.getCenter(dialogFinder);

    // Verify it moved from center
    expect(centerAfterFirstDrag.dx, greaterThan(400));
    expect(centerAfterFirstDrag.dy, greaterThan(300));

    // Drag MORE in the same direction
    await tester.drag(dialogFinder, const Offset(100, 100));
    await tester.pump();

    final centerAfterSecondDrag = tester.getCenter(dialogFinder);

    // Should be at the same position (clamped)
    expect(centerAfterSecondDrag, equals(centerAfterFirstDrag));

    // Reset window size
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  });

  testWidgets('dragging works with default size (no width/height provided)',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  showDraggableDialogWithBuilder(
                    context: context,
                    // No width or height provided
                    builder: (context, onDragUpdate) {
                      return GestureDetector(
                        onPanUpdate: onDragUpdate,
                        child: Container(
                            color: Colors.yellow,
                            child: const Text('Default Size Drag')),
                      );
                    },
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

    final dialogFinder = find.text('Default Size Drag');
    final initialLocation = tester.getCenter(dialogFinder);

    // Drag the dialog
    await tester.drag(dialogFinder, const Offset(50, 50));
    await tester.pump();

    final newLocation = tester.getCenter(dialogFinder);

    // It should move
    expect(newLocation, isNot(equals(initialLocation)));
    expect(newLocation.dx, greaterThan(initialLocation.dx));
    expect(newLocation.dy, greaterThan(initialLocation.dy));
  });

  testWidgets('initialAlignment is respected', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  showDraggableDialogWithBuilder(
                    context: context,
                    initialAlignment: Alignment.topLeft,
                    builder: (context, onDragUpdate) {
                      return Container(
                          color: Colors.purple,
                          child: const Text('Aligned Dialog'));
                    },
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

    final dialogFinder = find.text('Aligned Dialog');
    final dialogCenter = tester.getCenter(dialogFinder);

    // TopLeft alignment means it should be in the top-left quadrant
    // Exact position depends on screen size, but we can check it's not center
    final screenSize = tester.view.physicalSize / tester.view.devicePixelRatio;
    final screenCenter = Offset(screenSize.width / 2, screenSize.height / 2);

    expect(dialogCenter.dx, lessThan(screenCenter.dx));
    expect(dialogCenter.dy, lessThan(screenCenter.dy));
  });

  testWidgets('dragging is disabled if dialog is larger than screen',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 300);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  showDraggableDialogWithBuilder(
                    context: context,
                    width: 500, // Larger than screen width (400)
                    height: 400, // Larger than screen height (300)
                    builder: (context, onDragUpdate) {
                      return GestureDetector(
                        onPanUpdate: onDragUpdate,
                        child: Container(
                            color: Colors.orange,
                            child: const Text('Large Dialog')),
                      );
                    },
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

    final dialogFinder = find.text('Large Dialog');
    final initialLocation = tester.getCenter(dialogFinder);

    // Try to drag
    await tester.drag(dialogFinder, const Offset(50, 50));
    await tester.pump();

    final newLocation = tester.getCenter(dialogFinder);

    // Should not move because slack is negative (or zero clamped logic effectively)
    expect(newLocation, equals(initialLocation));

    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  });
}
