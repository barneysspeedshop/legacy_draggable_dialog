import 'package:flutter/material.dart';

/// A theme to customize the appearance of the [DraggableDialog].
@immutable
class DraggableDialogThemeData {
  final Color? headerColor;
  final Color? contentColor;
  final Color? footerColor;
  final TextStyle? titleStyle;
  final Color? buttonColor;
  final ButtonStyle? buttonStyle;
  final TextStyle? buttonTextStyle;
  final double? headerHeight;
  final double? footerHeight;
  final double? buttonHeight;
  final double? buttonMinWidth;
  final double? buttonTextSize;
  final double? headerTextSize;
  final double? closeIconSize;
  final Color? closeIconColor;

  const DraggableDialogThemeData({
    this.headerColor,
    this.contentColor,
    this.footerColor,
    this.titleStyle,
    this.buttonColor,
    this.buttonStyle,
    this.buttonTextStyle,
    this.headerHeight,
    this.footerHeight,
    this.buttonHeight,
    this.buttonMinWidth,
    this.buttonTextSize,
    this.headerTextSize,
    this.closeIconSize,
    this.closeIconColor,
  });

  /// Creates a copy of this theme with the given fields replaced by the new values.
  DraggableDialogThemeData copyWith({
    Color? headerColor,
    Color? contentColor,
    Color? footerColor,
    TextStyle? titleStyle,
    Color? buttonColor,
    ButtonStyle? buttonStyle,
    TextStyle? buttonTextStyle,
    double? headerHeight,
    double? footerHeight,
    double? buttonHeight,
    double? buttonMinWidth,
    double? buttonTextSize,
    double? headerTextSize,
    double? closeIconSize,
    Color? closeIconColor,
  }) {
    return DraggableDialogThemeData(
      headerColor: headerColor ?? this.headerColor,
      contentColor: contentColor ?? this.contentColor,
      footerColor: footerColor ?? this.footerColor,
      titleStyle: titleStyle ?? this.titleStyle,
      buttonColor: buttonColor ?? this.buttonColor,
      buttonStyle: buttonStyle ?? this.buttonStyle,
      buttonTextStyle: buttonTextStyle ?? this.buttonTextStyle,
      headerHeight: headerHeight ?? this.headerHeight,
      footerHeight: footerHeight ?? this.footerHeight,
      buttonHeight: buttonHeight ?? this.buttonHeight,
      buttonMinWidth: buttonMinWidth ?? this.buttonMinWidth,
      buttonTextSize: buttonTextSize ?? this.buttonTextSize,
      headerTextSize: headerTextSize ?? this.headerTextSize,
      closeIconSize: closeIconSize ?? this.closeIconSize,
      closeIconColor: closeIconColor ?? this.closeIconColor,
    );
  }

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
class DraggableDialog extends StatefulWidget {
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

  /// The preferred height of the dialog.
  final double? height;

  /// The maximum height of the dialog.
  final double? maxHeight;

  /// Whether the content area should expand to fill the available space
  /// within the `maxHeight` constraint. Defaults to `true`.
  final bool expandContent;

  /// The theme to apply to the dialog's components. If not provided, a default
  /// theme is created based on the current [ThemeData].
  final DraggableDialogThemeData? theme;

  /// Whether the dialog can be resized via a handle in the footer.
  final bool resizable;

  /// Whether the body should be wrapped in a [SingleChildScrollView]. Defaults to `true`.
  final bool scrollable;

  /// Icon shown as the resize handle when [resizable] is enabled.
  ///
  /// If null, the value from [DialogFooter] is used.
  final IconData? resizeHandleIcon;

  /// Size of the resize handle icon when [resizable] is enabled.
  ///
  /// If null, the value from [DialogFooter] is used.
  final double? resizeHandleIconSize;

  const DraggableDialog({
    super.key,
    required this.body,
    required this.onDragUpdate,
    this.header,
    this.footer,
    this.width,
    this.height,
    this.maxHeight,
    this.expandContent = true,
    this.theme,
    this.scrollable = true,
    this.resizable = false,
    this.resizeHandleIcon,
    this.resizeHandleIconSize,
  });

  @override
  State<DraggableDialog> createState() => _DraggableDialogState();
}

class _DraggableDialogState extends State<DraggableDialog> {
  final ScrollController _bodyScrollController = ScrollController();
  double _widthOffset = 0;
  double _heightOffset = 0;

  void _handleResize(DragUpdateDetails details) {
    setState(() {
      _widthOffset -= details.delta.dx;
      _heightOffset += details.delta.dy;
    });
  }

  @override
  void dispose() {
    _bodyScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dialogTheme = widget.theme ?? DraggableDialogThemeData.from(context);
    final screenHeight = MediaQuery.of(context).size.height;

    final baseWidth = widget.width ?? 400.0;
    final baseHeight = widget.height ?? widget.maxHeight ?? screenHeight * 0.85;

    final effectiveWidth = (baseWidth + _widthOffset).clamp(200.0, double.infinity);
    final effectiveHeight = (baseHeight + _heightOffset).clamp(150.0, screenHeight);

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: effectiveHeight),
      child: Material(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          width: effectiveWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              if (widget.header != null)
                GestureDetector(
                  onPanUpdate: widget.onDragUpdate,
                  child: Container(
                    height: dialogTheme.headerHeight,
                    color: dialogTheme.headerColor,
                    child: widget.header,
                  ),
                ),

              // Body
              _buildBody(dialogTheme),

              // Footer
              if (widget.footer != null)
                Container(
                  height: dialogTheme.footerHeight,
                  color: dialogTheme.footerColor,
                  child: _buildFooter(dialogTheme),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(DraggableDialogThemeData dialogTheme) {
    if (!widget.scrollable) {
      final content = Material(color: dialogTheme.contentColor, child: widget.body);
      return widget.expandContent ? Expanded(child: content) : content;
    }

    if (widget.expandContent) {
      return Expanded(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Scrollbar(
              controller: _bodyScrollController,
              child: SingleChildScrollView(
                controller: _bodyScrollController,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Material(
                    color: dialogTheme.contentColor,
                    child: widget.body,
                  ),
                ),
              ),
            );
          },
        ),
      );
    } else {
      return Scrollbar(
        controller: _bodyScrollController,
        child: SingleChildScrollView(
          controller: _bodyScrollController,
          child: Material(color: dialogTheme.contentColor, child: widget.body),
        ),
      );
    }
  }

  Widget _buildFooter(DraggableDialogThemeData dialogTheme) {
    final footerWidget = widget.footer!;

    if (widget.resizable && footerWidget is DialogFooter) {
      return DialogFooter(
        onOk: footerWidget.onOk,
        onCancel: footerWidget.onCancel,
        okText: footerWidget.okText,
        cancelText: footerWidget.cancelText,
        theme: footerWidget.theme,
        onResizeUpdate: _handleResize,
        resizeHandleIcon: widget.resizeHandleIcon ?? footerWidget.resizeHandleIcon,
        resizeHandleIconSize: widget.resizeHandleIconSize ?? footerWidget.resizeHandleIconSize,
      );
    }

    return footerWidget;
  }
}

/// A default implementation for the dialog's footer with OK and Cancel buttons.
class DialogFooter extends StatelessWidget {
  final VoidCallback? onOk;
  final VoidCallback? onCancel;
  final String okText;
  final String cancelText;
  final DraggableDialogThemeData theme;
  final void Function(DragUpdateDetails)? onResizeUpdate;
  final IconData resizeHandleIcon;
  final double? resizeHandleIconSize;

  const DialogFooter({
    super.key,
    this.onOk,
    this.onCancel,
    this.okText = 'OK',
    this.cancelText = 'Cancel',
    required this.theme,
    this.onResizeUpdate,
    this.resizeHandleIcon = Icons.drag_handle,
    this.resizeHandleIconSize,
  });

  @override
  Widget build(BuildContext context) {
    // Resolve button style with height, width, and color constraints
    ButtonStyle? effectiveButtonStyle = theme.buttonStyle;
    if (theme.buttonHeight != null || theme.buttonMinWidth != null) {
      effectiveButtonStyle = (effectiveButtonStyle ?? const ButtonStyle()).copyWith(
        minimumSize: WidgetStateProperty.all(
          Size(theme.buttonMinWidth ?? 0, theme.buttonHeight ?? 0),
        ),
      );
    }
    if (theme.buttonColor != null) {
      effectiveButtonStyle = (effectiveButtonStyle ?? const ButtonStyle()).copyWith(
        backgroundColor: WidgetStateProperty.all(theme.buttonColor),
      );
    }

    // Resolve button text style with text size
    TextStyle? effectiveButtonTextStyle = theme.buttonTextStyle;
    if (theme.buttonTextSize != null) {
      effectiveButtonTextStyle = (effectiveButtonTextStyle ?? const TextStyle()).copyWith(
        fontSize: theme.buttonTextSize,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          if (onResizeUpdate != null)
            GestureDetector(
              onPanUpdate: onResizeUpdate,
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeDownRight,
                child: Icon(
                  resizeHandleIcon,
                  size: resizeHandleIconSize ?? theme.buttonTextSize ?? 18,
                  color: theme.buttonColor?.withValues(alpha: 0.5) ?? Colors.grey,
                ),
              ),
            ),
          const Spacer(),
          if (onCancel != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ElevatedButton(
                onPressed: onCancel,
                style: effectiveButtonStyle,
                child: Text(cancelText, style: effectiveButtonTextStyle),
              ),
            ),
          if (onOk != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ElevatedButton(
                onPressed: onOk,
                style: effectiveButtonStyle,
                child: Text(okText, style: effectiveButtonTextStyle),
              ),
            ),
        ],
      ),
    );
  }
}
