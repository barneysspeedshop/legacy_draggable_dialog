import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:legacy_draggable_dialog/draggable_dialog.dart';
import 'package:legacy_draggable_dialog/legacy_draggable_dialog.dart';

void main() {
  Future<void> openDialog(
    WidgetTester tester,
    void Function(BuildContext context) show,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => show(context),
                child: const Text('Show Dialog'),
              );
            },
          ),
        ),
      ),
    );
    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();
  }

  testWidgets('from overlays a theme extension and keeps null fields', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.light().copyWith(
          extensions: const <ThemeExtension<dynamic>>[
            DraggableDialogThemeData(headerColor: Colors.indigo),
          ],
        ),
        home: Builder(
          builder: (context) {
            final theme = DraggableDialogThemeData.from(context);
            expect(theme.headerColor, Colors.indigo);
            expect(theme.contentColor, Colors.white);
            return const SizedBox();
          },
        ),
      ),
    );
  });

  testWidgets('showHeader false omits the title and a custom header', (
    WidgetTester tester,
  ) async {
    await openDialog(tester, (context) {
      showLegacyDraggableDialog(
        context: context,
        title: 'Hidden Title',
        header: const Text('Custom Header'),
        showHeader: false,
        body: const Text('Visible Body'),
        footer: const Text('Footer'),
      );
    });

    expect(find.text('Hidden Title'), findsNothing);
    expect(find.text('Custom Header'), findsNothing);
    expect(find.text('Visible Body'), findsOneWidget);
  });

  testWidgets('a hidden header does not count as a way to close', (
    WidgetTester tester,
  ) async {
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
                      header: const Text('Hidden'),
                      showHeader: false,
                      barrierDismissible: false,
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

  testWidgets('dragging the title moves the dialog and dragging close does not',
      (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(800, 600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await openDialog(tester, (context) {
      showLegacyDraggableDialog(
        context: context,
        title: 'Drag Title',
        body: const Text('Body'),
        width: 360,
        height: 220,
        onClose: () {},
      );
    });

    final title = find.text('Drag Title');
    final start = tester.getCenter(title);

    await tester.drag(find.byIcon(Icons.close), const Offset(120, 80));
    await tester.pump();
    expect(tester.getCenter(title), start);

    await tester.drag(title, const Offset(120, 80));
    await tester.pump();
    final moved = tester.getCenter(title);
    expect(moved.dx, greaterThan(start.dx));
    expect(moved.dy, greaterThan(start.dy));
  });

  testWidgets('default scrollable wraps the body in a SingleChildScrollView', (
    WidgetTester tester,
  ) async {
    await openDialog(tester, (context) {
      showLegacyDraggableDialog(
        context: context,
        title: 'Scrolls',
        body: const Text('Scroll Body'),
        onClose: () {},
      );
    });

    expect(
      find.descendant(
        of: find.byType(DraggableDialog),
        matching: find.byType(SingleChildScrollView),
      ),
      findsOneWidget,
    );
  });

  testWidgets('scrollable false does not wrap the body', (
    WidgetTester tester,
  ) async {
    await openDialog(tester, (context) {
      showLegacyDraggableDialog(
        context: context,
        title: 'Plain',
        body: const Text('Plain Body'),
        scrollable: false,
        onClose: () {},
      );
    });

    expect(
      find.descendant(
        of: find.byType(DraggableDialog),
        matching: find.byType(SingleChildScrollView),
      ),
      findsNothing,
    );
  });

  testWidgets('resizable true adds a handle beside a custom footer', (
    WidgetTester tester,
  ) async {
    await openDialog(tester, (context) {
      showLegacyDraggableDialog(
        context: context,
        body: const Text('Body'),
        footer: const Padding(
          padding: EdgeInsets.all(8),
          child: Text('Plain footer'),
        ),
        resizable: true,
      );
    });

    expect(find.text('Plain footer'), findsOneWidget);
    expect(find.byIcon(Icons.drag_handle), findsOneWidget);
  });

  testWidgets('resizable false leaves a custom footer without a handle', (
    WidgetTester tester,
  ) async {
    await openDialog(tester, (context) {
      showLegacyDraggableDialog(
        context: context,
        body: const Text('Body'),
        footer: const Text('Plain footer'),
        resizable: false,
      );
    });

    expect(find.text('Plain footer'), findsOneWidget);
    expect(find.byIcon(Icons.drag_handle), findsNothing);
  });

  testWidgets('resizable DialogFooter still shows the drag handle', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DraggableDialog(
            body: const Text('Body'),
            onDragUpdate: (_) {},
            resizable: true,
            footer: DialogFooter(
              theme: const DraggableDialogThemeData(),
              onOk: () {},
            ),
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.drag_handle), findsOneWidget);
  });

  testWidgets('deprecated headerHeight still sets the header container height',
      (
    WidgetTester tester,
  ) async {
    await openDialog(tester, (context) {
      showLegacyDraggableDialog(
        context: context,
        title: 'Height Check',
        body: const Text('Body'),
        headerHeight: 80,
        onClose: () {},
      );
    });

    final headerFinder = find.ancestor(
      of: find.text('Height Check'),
      matching: find.byWidgetPredicate(
        (widget) => widget is Container && widget.color != null,
      ),
    );
    expect(headerFinder, findsOneWidget);
    expect(tester.widget<Container>(headerFinder).constraints?.maxHeight, 80);
    expect(tester.getSize(headerFinder).height, 80);
  });

  testWidgets('theme shape and elevation are used by Material', (
    WidgetTester tester,
  ) async {
    const shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DraggableDialog(
            body: const Text('Shaped'),
            onDragUpdate: (_) {},
            theme: const DraggableDialogThemeData(shape: shape, elevation: 6),
          ),
        ),
      ),
    );

    final material = tester.widget<Material>(
      find
          .descendant(
            of: find.byType(DraggableDialog),
            matching: find.byType(Material),
          )
          .first,
    );
    expect(material.elevation, 6);
    expect(material.shape, shape);
  });

  testWidgets('minWidth is the lower width clamp', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: DraggableDialog(
              width: 100,
              theme: const DraggableDialogThemeData(minWidth: 320),
              body: const Text('Clamped'),
              onDragUpdate: (_) {},
            ),
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byType(DraggableDialog)).width, 320);
  });
}
