import 'package:flutter/material.dart';

/// A theme to customize the appearance of the [DraggableDialog].
@immutable
class DraggableDialogThemeData {
  final Color? headerColor;
  final Color? contentColor;
  final Color? footerColor;
  final TextStyle? titleStyle;
  final ButtonStyle? buttonStyle;
  final TextStyle? buttonTextStyle;

  const DraggableDialogThemeData({
    this.headerColor,
    this.contentColor,
    this.footerColor,
    this.titleStyle,
    this.buttonStyle,
    this.buttonTextStyle,
  });

  /// Creates a default theme for the dialog based on the current [ThemeData].
  factory DraggableDialogThemeData.from(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return isDarkMode
        ? DraggableDialogThemeData(
            headerColor: Colors.grey[800],
            contentColor: const Color(0xFF202020),
            footerColor: Colors.grey[850],
            titleStyle:
                theme.textTheme.titleLarge?.copyWith(color: Colors.white70),
            buttonStyle: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3b89b9),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
            ),
            buttonTextStyle:
                theme.textTheme.labelLarge?.copyWith(color: Colors.white),
          )
        : DraggableDialogThemeData(
            headerColor: Colors.blueGrey[50],
            contentColor: Colors.white,
            footerColor: Colors.grey[100],
            titleStyle:
                theme.textTheme.titleLarge?.copyWith(color: Colors.black87),
            buttonStyle: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3b89b9),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
            ),
            buttonTextStyle:
                theme.textTheme.labelLarge?.copyWith(color: Colors.white),
          );
  }
}

/// A highly customizable dialog widget with a draggable header.
///
/// This widget provides a structured layout with a header, content, and footer,
/// each of which can be replaced with a custom widget.
class DraggableDialog extends StatelessWidget {
  /// The widget to display in the header. If null, the header is not shown.
  /// The header is the draggable area of the dialog.
  final Widget? header;

  /// The main content of the dialog. This is the only required part.
  final Widget body;

  /// The widget to display in the footer, typically for action buttons.
  /// If null, the footer is not shown.
  final Widget? footer;

  /// The callback for drag updates, which should be applied to the draggable
  /// part of the dialog (usually the header).
  final void Function(DragUpdateDetails) onDragUpdate;

  /// The width of the dialog.
  final double? width;

  /// The maximum height of the dialog.
  final double? maxHeight;

  /// Whether the content area should expand to fill the available space
  /// within the `maxHeight` constraint. Defaults to `true`.
  final bool expandContent;

  /// The theme to apply to the dialog's components. If not provided, a default
  /// theme is created based on the current [ThemeData].
  final DraggableDialogThemeData? theme;

  const DraggableDialog({
    super.key,
    required this.body,
    required this.onDragUpdate,
    this.header,
    this.footer,
    this.width,
    this.maxHeight,
    this.expandContent = true,
    this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final dialogTheme = theme ?? DraggableDialogThemeData.from(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final effectiveMaxHeight = maxHeight ?? screenHeight * 0.85;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: effectiveMaxHeight),
      child: Material(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          width: width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              if (header != null)
                GestureDetector(
                  onPanUpdate: onDragUpdate,
                  child: Container(
                    color: dialogTheme.headerColor,
                    child: header,
                  ),
                ),

              // Body
              _buildBody(dialogTheme),

              // Footer
              if (footer != null)
                Container(
                  color: dialogTheme.footerColor,
                  child: footer,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(DraggableDialogThemeData dialogTheme) {
    final bodyContainer = Container(
      color: dialogTheme.contentColor,
      child: body,
    );

    if (expandContent) {
      return Expanded(child: bodyContainer);
    } else {
      return bodyContainer;
    }
  }
}

/// A default implementation for the dialog's footer with OK and Cancel buttons.
class DialogFooter extends StatelessWidget {
  final VoidCallback? onOk;
  final VoidCallback? onCancel;
  final String okText;
  final String cancelText;
  final DraggableDialogThemeData theme;

  const DialogFooter({
    super.key,
    this.onOk,
    this.onCancel,
    this.okText = 'OK',
    this.cancelText = 'Cancel',
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (onCancel != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ElevatedButton(
                onPressed: onCancel,
                style: theme.buttonStyle,
                child: Text(cancelText, style: theme.buttonTextStyle),
              ),
            ),
          if (onOk != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ElevatedButton(
                onPressed: onOk,
                style: theme.buttonStyle,
                child: Text(okText, style: theme.buttonTextStyle),
              ),
            ),
        ],
      ),
    );
  }
}
