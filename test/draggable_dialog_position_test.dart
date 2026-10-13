import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:legacy_draggable_dialog/legacy_draggable_dialog.dart';

const _surfaceKey = ValueKey('dialog surface');
const _rightHandleKey = ValueKey('right resize handle');

Future<void> _open(
  WidgetTester tester,
  void Function(BuildContext context) open, {
  Size viewport = const Size(1000, 800),
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = viewport;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => Center(
            child: ElevatedButton(
              onPressed: () => open(context),
              child: const Text('Open dialog'),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('Open dialog'));
  await tester.pumpAndSettle();
}

void _fixed(BuildContext context, {double width = 400, double height = 300}) {
  showDraggableDialogWithBuilder<void>(
    context: context,
    width: width,
    height: height,
    builder: (context, drag) => Material(
      key: _surfaceKey,
      color: Colors.white,
      child: Builder(
        builder: (context) => Column(
          children: [
            GestureDetector(
              onPanUpdate: drag,
              child: const SizedBox(
                height: 40,
                width: double.infinity,
                child: Text('Move dialog'),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onPanUpdate: ResizeHandleProvider.leftOf(context),
                child: const ColoredBox(
                  color: Colors.grey,
                  child: Center(child: Text('Left handle')),
                ),
              ),
            ),
            GestureDetector(
              key: _rightHandleKey,
              onPanUpdate: ResizeHandleProvider.of(context),
              child: const SizedBox(
                height: 40,
                width: double.infinity,
                child: Text('Right handle'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Rect _rect(WidgetTester tester) => tester.getRect(find.byKey(_surfaceKey));

void _within(Rect rect, Rect bounds) {
  expect(rect.left, greaterThanOrEqualTo(bounds.left - 0.01));
  expect(rect.top, greaterThanOrEqualTo(bounds.top - 0.01));
  expect(rect.right, lessThanOrEqualTo(bounds.right + 0.01));
  expect(rect.bottom, lessThanOrEqualTo(bounds.bottom + 0.01));
}

void main() {
  testWidgets('drag deltas stay one-to-one with the pointer', (tester) async {
    await _open(tester, _fixed);
    final before = _rect(tester);
    await tester.drag(find.text('Move dialog'), const Offset(45, 30));
    await tester.pumpAndSettle();
    final after = _rect(tester);
    expect(after.left, closeTo(before.left + 45, 0.01));
    expect(after.top, closeTo(before.top + 30, 0.01));
    expect(after.size, before.size);
  });

  testWidgets('bottom-left resize anchors the right edge', (tester) async {
    await _open(tester, _fixed);
    final before = _rect(tester);
    await tester.drag(find.text('Left handle'), const Offset(-50, 40));
    await tester.pumpAndSettle();
    final resized = _rect(tester);
    expect(resized.left, closeTo(before.left - 50, 0.01));
    expect(resized.right, closeTo(before.right, 0.01));
    expect(resized.height, closeTo(before.height + 40, 0.01));
  });

  testWidgets('bottom-right resize anchors the top-left corner',
      (tester) async {
    await _open(tester, _fixed);
    final before = _rect(tester);
    await tester.drag(find.byKey(_rightHandleKey), const Offset(60, 50));
    await tester.pumpAndSettle();
    final resized = _rect(tester);
    expect(resized.topLeft, before.topLeft);
    expect(resized.width, closeTo(before.width + 60, 0.01));
    expect(resized.height, closeTo(before.height + 50, 0.01));
  });

  testWidgets('an oversized dialog shrinks into the padded viewport',
      (tester) async {
    await _open(
      tester,
      (context) => _fixed(context, width: 600, height: 600),
      viewport: const Size(360, 696),
    );
    final rect = _rect(tester);
    expect(rect.width, closeTo(340, 0.01));
    _within(rect, const Rect.fromLTRB(10, 10, 350, 686));
    await tester.drag(find.text('Move dialog'), const Offset(1000, 1000));
    await tester.pumpAndSettle();
    _within(_rect(tester), const Rect.fromLTRB(10, 10, 350, 686));
  });

  testWidgets('safe areas and the keyboard reflow an open dialog',
      (tester) async {
    await _open(tester, (context) => _fixed(context, width: 600, height: 600));
    tester.view.viewPadding = const FakeViewPadding(
      left: 20,
      top: 32,
      right: 24,
      bottom: 16,
    );
    tester.view.padding = const FakeViewPadding(left: 20, top: 32, right: 24);
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    await tester.pumpAndSettle();
    _within(_rect(tester), const Rect.fromLTRB(30, 42, 966, 490));
  });
}
