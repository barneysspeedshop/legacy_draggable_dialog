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
  @Deprecated(
    'Set this on DraggableDialogThemeData instead. This argument still overrides theme.',
  )
  double? headerHeight,
  @Deprecated(
    'Set this on DraggableDialogThemeData instead. This argument still overrides theme.',
  )
  double? footerHeight,
  @Deprecated(
    'Set this on DraggableDialogThemeData instead. This argument still overrides theme.',
  )
  double? buttonHeight,
  @Deprecated(
    'Set this on DraggableDialogThemeData instead. This argument still overrides theme.',
  )
  double? buttonMinWidth,
  @Deprecated(
    'Set this on DraggableDialogThemeData instead. This argument still overrides theme.',
  )
  double? buttonTextSize,
  @Deprecated(
    'Set this on DraggableDialogThemeData instead. This argument still overrides theme.',
  )
  double? headerTextSize,
  @Deprecated(
    'Set this on DraggableDialogThemeData instead. This argument still overrides theme.',
  )
  double? closeIconSize,
  @Deprecated(
    'Set this on DraggableDialogThemeData instead. This argument still overrides theme.',
  )
  TextStyle? titleStyle,
  @Deprecated(
    'Set this on DraggableDialogThemeData instead. This argument still overrides theme.',
  )
  Color? closeIconColor,
  @Deprecated(
    'Set this on DraggableDialogThemeData instead. This argument still overrides theme.',
  )
  Color? buttonColor,
  bool expandContent = true,
  Alignment initialAlignment = Alignment.center,
  bool barrierDismissible = true,
  Color barrierColor = Colors.black54,
  EdgeInsets insetPadding = const EdgeInsets.all(10.0),
  DraggableDialogThemeData? theme,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  RouteTransitionsBuilder? transitionBuilder,
  bool scrollable = true,
  bool resizable = false,
  IconData? resizeHandleIcon,
  double? resizeHandleIconSize,
  bool showHeader = true,
}) {
  final bool hasClosingMechanism = onClose != null ||
      onOk != null ||
      onCancel != null ||
      (showHeader && header != null) ||
      footer != null ||
      (actions != null && actions.isNotEmpty);

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
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    transitionBuilder: transitionBuilder,
    builder: (dialogContext, onDragUpdate) {
      final dialogTheme =
          (theme ?? DraggableDialogThemeData.from(dialogContext)).copyWith(
        headerHeight: headerHeight,
        footerHeight: footerHeight,
        buttonHeight: buttonHeight,
        buttonMinWidth: buttonMinWidth,
        buttonTextSize: buttonTextSize,
        buttonColor: buttonColor,
        headerTextSize: headerTextSize,
        closeIconSize: closeIconSize,
        titleStyle: titleStyle,
        closeIconColor: closeIconColor,
      );

      final Widget? effectiveHeader;
      final bool dragEntireHeader;
      if (!showHeader) {
        effectiveHeader = null;
        dragEntireHeader = true;
      } else if (header != null) {
        effectiveHeader = header;
        dragEntireHeader = true;
      } else {
        dragEntireHeader = false;
        final double? effectiveHeaderTextSize = dialogTheme.headerTextSize ??
            (dialogTheme.headerHeight != null
                ? dialogTheme.headerHeight! * 0.35
                : null);

        final double? effectiveCloseIconSize = dialogTheme.closeIconSize ??
            (dialogTheme.headerHeight != null
                ? dialogTheme.headerHeight! * 0.5
                : null);

        effectiveHeader = Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: dialogTheme.headerHeight == null ? 8.0 : 0.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanUpdate: onDragUpdate,
                  child: Text(
                    title,
                    style: (dialogTheme.titleStyle ?? const TextStyle())
                        .copyWith(fontSize: effectiveHeaderTextSize),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              if (onClose != null)
                IconButton(
                  iconSize: effectiveCloseIconSize,
                  icon: Icon(
                    Icons.close,
                    color: dialogTheme.closeIconColor ??
                        dialogTheme.titleStyle?.color,
                  ),
                  onPressed: onClose,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: 'Close',
                ),
            ],
          ),
        );
      }

      // Default Footer
      Widget? effectiveFooter;
      if (footer != null) {
        effectiveFooter = footer;
      } else if (actions != null) {
        effectiveFooter = Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: actions
                .map((e) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: e))
                .toList(),
          ),
        );
      } else if (onOk != null || onCancel != null) {
        effectiveFooter = DialogFooter(
            onOk: onOk,
            onCancel: onCancel,
            okText: okText,
            cancelText: cancelText,
            theme: dialogTheme);
      }

      return DraggableDialog(
        onDragUpdate: onDragUpdate,
        header: effectiveHeader,
        dragEntireHeader: dragEntireHeader,
        body: body,
        footer: effectiveFooter,
        width: width,
        maxHeight: maxHeight,
        expandContent: expandContent,
        theme: dialogTheme,
        scrollable: scrollable,
        resizable: resizable,
        resizeHandleIcon: resizeHandleIcon,
        resizeHandleIconSize: resizeHandleIconSize,
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
  required Widget Function(
          BuildContext context, void Function(DragUpdateDetails) onDragUpdate)
      builder,
  double? width,
  double? height,
  Alignment initialAlignment = Alignment.center,
  bool barrierDismissible = true,
  Color barrierColor = Colors.black54,
  EdgeInsets insetPadding = const EdgeInsets.all(10.0),
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  RouteTransitionsBuilder? transitionBuilder,
}) {
  Alignment currentDialogAlignmentState = initialAlignment;

  final GlobalKey dialogKey = GlobalKey();

  return showGeneralDialog<T>(
    context: context,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    transitionBuilder: transitionBuilder,
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: barrierColor,
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      return StatefulBuilder(
        builder: (builderContext, setState) {
          void handleHeaderPanUpdate(DragUpdateDetails details) {
            final currentScreenSize = MediaQuery.of(builderContext).size;

            // Measure actual rendered dialog size so slack is accurate even
            // when the dialog is smaller than the width/height constraints.
            Size actualDialogSize = Size(
              width ?? (currentScreenSize.width * 0.8),
              height ?? (currentScreenSize.height * 0.8),
            );
            final renderBox =
                dialogKey.currentContext?.findRenderObject() as RenderBox?;
            if (renderBox != null && renderBox.hasSize) {
              actualDialogSize = Size(
                width ?? renderBox.size.width,
                height ?? renderBox.size.height,
              );
            }

            final double effectiveScreenWidth =
                currentScreenSize.width - insetPadding.horizontal;
            final double effectiveScreenHeight =
                currentScreenSize.height - insetPadding.vertical;

            final double halfSlackWidth =
                (effectiveScreenWidth - actualDialogSize.width) / 2.0;
            final double halfSlackHeight =
                (effectiveScreenHeight - actualDialogSize.height) / 2.0;

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
              currentDialogAlignmentState = Alignment(
                  newAlignmentX.clamp(-1.0, 1.0),
                  newAlignmentY.clamp(-1.0, 1.0));
            });
          }

          return Dialog(
            alignment: currentDialogAlignmentState,
            insetPadding: insetPadding,
            backgroundColor: Colors.transparent,
            elevation: 0, // Elevation is on the Material child
            child: KeyedSubtree(
              key: dialogKey,
              child: builder(builderContext, handleHeaderPanUpdate),
            ),
          );
        },
      );
    }, // Close pageBuilder
  );
}
