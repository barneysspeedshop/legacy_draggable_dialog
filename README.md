A draggable dialog helper for Flutter.

## Features

* Draggable dialog with a draggable header.
* Highly customizable dialog with a header, content, and footer.
* The dialog can be dismissed by swiping it down.

## Getting started

Add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  legacy_draggable_dialog: ^0.0.1
```

## Usage

```dart
DraggableDialog(
  body: const Text('Hello World'),
  onDragUpdate: (details) {},
)
```