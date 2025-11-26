import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example/main.dart';

void main() {
  setUp(() {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.window.physicalSizeTestValue = const Size(1920, 1080);
    binding.window.devicePixelRatioTestValue = 1.0;
  });

  tearDown(() {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.window.clearPhysicalSizeTestValue();
    binding.window.clearDevicePixelRatioTestValue();
  });

  testWidgets('Draggable Dialog Demo smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our app title is present.
    expect(find.text('Draggable Dialog Demo'), findsOneWidget);
  });

  testWidgets('Simple Dialog test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    final buttonFinder = find.text('Show Simple Dialog');
    await tester.scrollUntilVisible(buttonFinder, 500.0);
    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();

    expect(find.text('Simple Dialog'), findsOneWidget);
    expect(find.text('This is a basic dialog with OK button.'), findsOneWidget);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.text('Simple Dialog'), findsNothing);
  });

  testWidgets('Simple Dialog with Close Button test', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    final buttonFinder = find.text(
      'Show Simple Dialog With Close Button in Title',
    );
    await tester.scrollUntilVisible(buttonFinder, 500.0);
    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();

    expect(find.text('Simple Dialog'), findsOneWidget);
    // Find the close icon in the header (IconButton)
    expect(find.widgetWithIcon(IconButton, Icons.close), findsOneWidget);

    await tester.tap(find.widgetWithIcon(IconButton, Icons.close));
    await tester.pumpAndSettle();
    expect(find.text('Simple Dialog'), findsNothing);
  });

  testWidgets('Custom Actions Dialog test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    final buttonFinder = find.text('Show Dialog with Custom Actions');
    await tester.scrollUntilVisible(buttonFinder, 500.0);
    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();

    expect(find.text('Dialog with Actions'), findsOneWidget);
    expect(find.byType(Checkbox), findsOneWidget);
    expect(find.text('Option'), findsOneWidget);
    expect(find.text('Help'), findsOneWidget);
    expect(find.text('Confirm'), findsOneWidget);

    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    // Verify checkbox state change if possible, but mainly just interaction

    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();
    expect(find.text('Dialog with Actions'), findsNothing);
  });

  testWidgets('Custom Footer Dialog test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    final buttonFinder = find.text('Show Dialog with Custom Footer');
    await tester.scrollUntilVisible(buttonFinder, 500.0);
    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();

    expect(find.text('Custom Footer'), findsOneWidget);
    expect(find.byIcon(Icons.info_outline), findsOneWidget);
    expect(find.text('Dismiss'), findsOneWidget);

    await tester.tap(find.text('Dismiss'));
    await tester.pumpAndSettle();
    expect(find.text('Custom Footer'), findsNothing);
  });

  testWidgets('Custom Header Dialog test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    final buttonFinder = find.text('Show Dialog with Custom Header');
    await tester.scrollUntilVisible(buttonFinder, 500.0);
    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();

    expect(find.text('Custom Draggable Header'), findsOneWidget);
    expect(find.byIcon(Icons.drag_handle), findsOneWidget);

    await tester.tap(find.widgetWithIcon(IconButton, Icons.close));
    await tester.pumpAndSettle();
    expect(find.text('Custom Draggable Header'), findsNothing);
  });

  testWidgets('Dialog with Themed Button test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    final buttonFinder = find.text('Show Dialog with Themed Button');
    await tester.scrollUntilVisible(buttonFinder, 500.0);
    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();

    expect(find.text('Dialog with Themed Button'), findsOneWidget);
    expect(find.text('Themed OK'), findsOneWidget);

    await tester.tap(find.text('Themed OK'));
    await tester.pumpAndSettle();
    expect(find.text('Dialog with Themed Button'), findsNothing);
  });

  testWidgets('Dialog with Danger Theme test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    final buttonFinder = find.text('Show Dialog with Danger Theme');
    await tester.scrollUntilVisible(buttonFinder, 500.0);
    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();

    expect(find.text('Danger Zone'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);

    // Verify button color is red (danger)
    final button = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Delete'),
    );
    expect(button.style?.backgroundColor?.resolve({}), Colors.red);

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(find.text('Danger Zone'), findsNothing);
  });

  testWidgets('Dialog with Success Theme test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    final buttonFinder = find.text('Show Dialog with Success Theme');
    await tester.scrollUntilVisible(buttonFinder, 500.0);
    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();

    expect(find.text('Success!'), findsOneWidget);
    expect(find.text('Great!'), findsOneWidget);

    // Verify title style
    final title = tester.widget<Text>(find.text('Success!'));
    expect(title.style?.color, Colors.green);

    await tester.tap(find.text('Great!'));
    await tester.pumpAndSettle();
    expect(find.text('Success!'), findsNothing);
  });

  testWidgets('Dialog with Custom Buttons test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    final buttonFinder = find.text('Show Dialog with Custom Buttons');
    await tester.scrollUntilVisible(buttonFinder, 500.0);
    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();

    expect(find.text('Dialog with Custom Buttons'), findsOneWidget);
    expect(find.text('TextButton'), findsOneWidget);
    expect(find.text('Outlined'), findsOneWidget);
    expect(find.text('Elevated'), findsOneWidget);

    await tester.tap(find.text('Elevated'));
    await tester.pumpAndSettle();
    expect(find.text('Dialog with Custom Buttons'), findsNothing);
  });

  testWidgets('Scrollable Dialog test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    final buttonFinder = find.text('Show Dialog with Scrollable Body');
    await tester.scrollUntilVisible(buttonFinder, 500.0);
    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();

    expect(find.text('Scrollable Content'), findsOneWidget);
    expect(find.text('Item 1'), findsOneWidget);
    expect(find.text('Item 5'), findsOneWidget);

    // Scroll down
    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pump();

    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();
    expect(find.text('Scrollable Content'), findsNothing);
  });

  testWidgets('Expandable Dialog test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    final buttonFinder = find.text('Show Dialog with Expandable Sections');
    await tester.scrollUntilVisible(buttonFinder, 500.0);
    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();

    expect(find.text('Expandable Sections'), findsOneWidget);
    expect(find.text('User Information'), findsOneWidget);

    // Expand User Information
    await tester.tap(find.text('User Information'));
    await tester.pumpAndSettle();
    expect(find.text('Name: John Doe'), findsOneWidget);

    // Close dialog (using the close button in header which is default when onClose is provided)
    // Wait, the example uses onClose which adds a close button to the header if not custom header
    // Let's check the code: _showExpandableDialog uses onClose.
    // So there should be a close button.
    await tester.tap(find.widgetWithIcon(IconButton, Icons.close));
    await tester.pumpAndSettle();
    expect(find.text('Expandable Sections'), findsNothing);
  });

  testWidgets('Form Dialog test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    final buttonFinder = find.text('Show Dialog with Form');
    await tester.scrollUntilVisible(buttonFinder, 500.0);
    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();

    expect(find.text('Login Form'), findsOneWidget);

    // Try to submit empty
    await tester.tap(find.text('Submit'));
    await tester.pump();
    expect(find.text('Please enter a username'), findsOneWidget);

    // Enter data
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Username'),
      'testuser',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Password'),
      'password123',
    );
    await tester.pump();

    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();
    expect(find.text('Login Form'), findsNothing);
  });

  testWidgets('Loading Dialog test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    final buttonFinder = find.text('Show Loading Dialog');
    await tester.scrollUntilVisible(buttonFinder, 500.0);
    await tester.tap(buttonFinder);
    await tester
        .pump(); // Just pump, don't settle yet as it might have animation

    expect(find.text('Processing...'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for the 3 seconds delay
    await tester.pumpAndSettle(const Duration(seconds: 4));
    expect(find.text('Processing...'), findsNothing);
  });

  testWidgets('Tabbed Dialog test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    final buttonFinder = find.text('Show Dialog with Tabs');
    await tester.scrollUntilVisible(buttonFinder, 500.0);
    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();

    expect(find.text('Tabbed Content'), findsOneWidget);
    expect(find.text('General Information'), findsOneWidget);

    // Tap second tab
    await tester.tap(find.byIcon(Icons.details));
    await tester.pumpAndSettle();
    expect(find.text('Detailed Specifications'), findsOneWidget);

    await tester.tap(find.widgetWithIcon(IconButton, Icons.close));
    await tester.pumpAndSettle();
    expect(find.text('Tabbed Content'), findsNothing);
  });

  testWidgets('Tabbed View Dialog test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    final buttonFinder = find.text('Show Dialog with Tabbed View Package');
    await tester.scrollUntilVisible(buttonFinder, 500.0);
    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();

    expect(find.text('Tabbed View Package'), findsOneWidget);
    expect(find.text('Content 1'), findsOneWidget);

    // Tap second tab - TabbedView might render tabs differently
    // We look for text 'Tab 2'
    await tester.tap(find.text('Tab 2'));
    await tester.pumpAndSettle();
    expect(find.text('Content 2'), findsOneWidget);

    await tester.tap(find.widgetWithIcon(IconButton, Icons.close));
    await tester.pumpAndSettle();
    expect(find.text('Tabbed View Package'), findsNothing);
  });

  testWidgets('Collapsible Dialog test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    final buttonFinder = find.text('Show Collapsible Dialog');
    await tester.scrollUntilVisible(buttonFinder, 500.0);
    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();

    expect(find.text('Collapsible Dialog'), findsOneWidget);
    expect(
      find.text(
        'This is the body of the collapsible dialog. Click the arrow in the header to collapse or expand me.',
      ),
      findsOneWidget,
    );

    // Collapse
    await tester.tap(find.byIcon(Icons.keyboard_arrow_up));
    await tester.pumpAndSettle();

    // Body should be gone (SizedBox.shrink) or not found
    expect(
      find.text(
        'This is the body of the collapsible dialog. Click the arrow in the header to collapse or expand me.',
      ),
      findsNothing,
    );

    // Expand
    await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
    await tester.pumpAndSettle();
    expect(
      find.text(
        'This is the body of the collapsible dialog. Click the arrow in the header to collapse or expand me.',
      ),
      findsOneWidget,
    );

    // Close
    await tester.tap(find.widgetWithIcon(IconButton, Icons.close));
    await tester.pumpAndSettle();
    expect(find.text('Collapsible Dialog'), findsNothing);
  });
}
