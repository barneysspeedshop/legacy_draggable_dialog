// lib/widgets/dialogs/draggable_dialog_helper.dart
import 'package:flutter/material.dart';
import 'package:legacy_draggable_dialog/draggable_dialog.dart';

/// Shows a highly customizable draggable dialog with a default layout.
///
/// This function simplifies showing a dialog with a header, body, and footer.
/// You can override any of these sections with your own widgets.
///
/// At least one closing mechanism must be available, either by providing an
/// `onClose` callback (which adds a close button to the default header), or by
/// ensuring the provided `header`, `body`, or `footer` widgets can pop the dialog.
Future<T?> showLegacyDraggableDialog<T>({
  required BuildContext context,
  required Widget body,
  String title = '',
  Widget? header,

  /// A custom widget for the footer. If provided, `actions`, `onOk`, and `onCancel` are ignored for the footer.
  Widget? footer,

  /// A list of widgets to display in the footer, typically buttons.
  List<Widget>? actions,
  VoidCallback? onOk,
  VoidCallback? onCancel,
  String okText = 'OK',
  String cancelText = 'Cancel',
  VoidCallback? onClose,
  double? width,
  double? height,
  double? maxHeight,
  bool expandContent = true,
  Alignment initialAlignment = Alignment.center,
  bool barrierDismissible = true,
  Color barrierColor = Colors.black54,
  EdgeInsets insetPadding = const EdgeInsets.all(10.0),
  DraggableDialogThemeData? theme,
}) {
  final bool hasClosingMechanism =
      onClose != null || onOk != null || onCancel != null || header != null || footer != null || (actions != null && actions.isNotEmpty);

  assert(
    barrierDismissible || hasClosingMechanism,
    'The dialog must have a way to be closed. Either provide a closing mechanism (e.g., onClose, onOk, onCancel) or set barrierDismissible to true.',
  );

  return showDraggableDialogWithBuilder<T>(
    context: context,
    width: width,
    height: height,
    initialAlignment: initialAlignment,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    insetPadding: insetPadding,
    builder: (dialogContext, onDragUpdate) {
      final dialogTheme = theme ?? DraggableDialogThemeData.from(dialogContext);

      // Default Header
      final Widget effectiveHeader =
          header ??
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: dialogTheme.titleStyle),
                if (onClose != null) IconButton(icon: const Icon(Icons.close), onPressed: onClose, tooltip: 'Close'),
              ],
            ),
          );

      // Default Footer
      Widget? effectiveFooter;
      if (footer != null) {
        effectiveFooter = footer;
      } else if (actions != null) {
        effectiveFooter = Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: actions.map((e) => Padding(padding: const EdgeInsets.symmetric(horizontal: 4.0), child: e)).toList(),
          ),
        );
      } else if (onOk != null || onCancel != null) {
        effectiveFooter = DialogFooter(onOk: onOk, onCancel: onCancel, okText: okText, cancelText: cancelText, theme: dialogTheme);
      }

      return DraggableDialog(
        onDragUpdate: onDragUpdate,
        header: effectiveHeader,
        body: body,
        footer: effectiveFooter,
        width: width,
        maxHeight: maxHeight,
        expandContent: expandContent,
        theme: dialogTheme,
      );
    },
  );
}

/// A generic helper to show a dialog that can be dragged around the screen.
///
/// This function provides the core dragging logic but allows the caller to define
/// the entire UI of the dialog via a `builder` function. The builder receives an
/// `onDragUpdate` handler that should be passed to a `GestureDetector` on the
/// part of the UI that will act as the drag handle.
Future<T?> showDraggableDialogWithBuilder<T>({
  required BuildContext context,
  required Widget Function(BuildContext context, void Function(DragUpdateDetails) onDragUpdate) builder,
  double? width,
  double? height,
  Alignment initialAlignment = Alignment.center,
  bool barrierDismissible = true,
  Color barrierColor = Colors.black54,
  EdgeInsets insetPadding = const EdgeInsets.all(10.0),
}) {
  Alignment currentDialogAlignmentState = initialAlignment;

  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: barrierColor,
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      return StatefulBuilder(
        builder: (builderContext, setState) {
          void handleHeaderPanUpdate(DragUpdateDetails details) {
            final currentScreenSize = MediaQuery.of(builderContext).size;
            final double modalWidth = width ?? (currentScreenSize.width * 0.8);
            final double modalHeight = height ?? (currentScreenSize.height * 0.8);

            double halfSlackWidth = (currentScreenSize.width - modalWidth) / 2.0;
            double halfSlackHeight = (currentScreenSize.height - modalHeight) / 2.0;

            double dAlignX = 0;
            if (halfSlackWidth > 1e-6) {
              dAlignX = details.delta.dx / halfSlackWidth;
            }

            double dAlignY = 0;
            if (halfSlackHeight > 1e-6) {
              dAlignY = details.delta.dy / halfSlackHeight;
            }

            setState(() {
              double newAlignmentX = currentDialogAlignmentState.x + dAlignX;
              double newAlignmentY = currentDialogAlignmentState.y + dAlignY;
              currentDialogAlignmentState = Alignment(newAlignmentX.clamp(-1.0, 1.0), newAlignmentY.clamp(-1.0, 1.0));
            });
          }

          return Dialog(
            alignment: currentDialogAlignmentState,
            insetPadding: insetPadding,
            backgroundColor: Colors.transparent,
            elevation: 0, // Elevation is on the Material child
            child: builder(builderContext, handleHeaderPanUpdate),
          );
        },
      );
    }, // Close pageBuilder
  );
}
