import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:legacy_draggable_dialog/draggable_dialog.dart';

void main() {
  group('DraggableDialogThemeData', () {
    testWidgets('from creates light theme correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: Builder(
            builder: (context) {
              final theme = DraggableDialogThemeData.from(context);
              expect(theme.headerColor, Colors.blueGrey[50]);
              expect(theme.contentColor, Colors.white);
              expect(theme.footerColor, Colors.grey[100]);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('from creates dark theme correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Builder(
            builder: (context) {
              final theme = DraggableDialogThemeData.from(context);
              expect(theme.headerColor, Colors.grey[800]);
              expect(theme.contentColor, const Color(0xFF202020));
              expect(theme.footerColor, Colors.grey[850]);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    test('constructor assigns values correctly', () {
      const theme = DraggableDialogThemeData(
          headerColor: Colors.red,
          contentColor: Colors.green,
          footerColor: Colors.blue);
      expect(theme.headerColor, Colors.red);
      expect(theme.contentColor, Colors.green);
      expect(theme.footerColor, Colors.blue);
    });
  });
}
