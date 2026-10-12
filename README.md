A draggable dialog helper for Flutter.

## Features

* Drag a dialog by its title. The dialog stays on screen.
* Replace the header, body, and footer.
* Theme the dialog with `DraggableDialogThemeData`, including as a `ThemeExtension`.

## Add the package

Add this dependency to `pubspec.yaml`:

```yaml
dependencies:
  legacy_draggable_dialog: ^0.1.2
```

## Show a dialog

Call `showLegacyDraggableDialog`. The title is the drag handle. `onClose` adds a close button. Dragging that button does not move the dialog.

```dart
showLegacyDraggableDialog(
  context: context,
  title: 'Details',
  body: const Text('Hello World'),
  onClose: () => Navigator.of(context).pop(),
);
```

To hide the header, set `showHeader` to false. To let the body scroll itself, set `scrollable` to false. To resize from the footer, set `resizable` to true.

## Theme one app

Set `DraggableDialogThemeData` on `ThemeData.extensions`. `DraggableDialogThemeData.from` reads that extension. Fields you leave null keep the built-in light and dark colors.

```dart
MaterialApp(
  theme: ThemeData(
    extensions: const [
      DraggableDialogThemeData(headerColor: Colors.indigo),
    ],
  ),
);
```

You can still pass `theme` on one call. Older arguments such as `buttonColor` and `headerHeight` still override `theme`. Set those fields on `DraggableDialogThemeData` instead.

For a fully custom shell, call `showDraggableDialogWithBuilder` and pass `onDragUpdate` to the widget that should drag.
