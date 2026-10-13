import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

typedef DragUpdateCallback = void Function(DragUpdateDetails details);

/// Provides drag, resize, and content-height callbacks to dialog chrome.
class ResizeHandleProvider extends InheritedWidget {
  final DragUpdateCallback? onResizeUpdate;
  final DragUpdateCallback? onResizeLeftUpdate;
  final DragUpdateCallback? onDragUpdate;
  final ValueChanged<double?>? onContentHeightChanged;

  const ResizeHandleProvider({
    super.key,
    required this.onResizeUpdate,
    this.onResizeLeftUpdate,
    this.onDragUpdate,
    this.onContentHeightChanged,
    required super.child,
  });

  static DragUpdateCallback? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ResizeHandleProvider>()
        ?.onResizeUpdate;
  }

  static DragUpdateCallback? leftOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ResizeHandleProvider>()
        ?.onResizeLeftUpdate;
  }

  static DragUpdateCallback? dragOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<ResizeHandleProvider>()
      ?.onDragUpdate;

  static ValueChanged<double?>? contentHeightOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<ResizeHandleProvider>()
      ?.onContentHeightChanged;

  @override
  bool updateShouldNotify(ResizeHandleProvider oldWidget) =>
      onResizeUpdate != oldWidget.onResizeUpdate ||
      onResizeLeftUpdate != oldWidget.onResizeLeftUpdate ||
      onDragUpdate != oldWidget.onDragUpdate ||
      onContentHeightChanged != oldWidget.onContentHeightChanged;
}

/// A theme to customize the appearance of the [DraggableDialog].
///
/// Set it on [ThemeData.extensions] or pass it as [DraggableDialog.theme].
/// [DraggableDialogThemeData.from] reads the extension and keeps built-in
/// values for fields left null.
@immutable
class DraggableDialogThemeData
    extends ThemeExtension<DraggableDialogThemeData> {
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
  final ShapeBorder? shape;
  final double? elevation;
  final double? minWidth;
  final double? minHeight;

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
    this.shape,
    this.elevation,
    this.minWidth,
    this.minHeight,
  }) : super();

  /// Creates a copy of this theme with the given fields replaced by the new values.
  @override
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
    ShapeBorder? shape,
    double? elevation,
    double? minWidth,
    double? minHeight,
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
      shape: shape ?? this.shape,
      elevation: elevation ?? this.elevation,
      minWidth: minWidth ?? this.minWidth,
      minHeight: minHeight ?? this.minHeight,
    );
  }

  @override
  DraggableDialogThemeData lerp(
    ThemeExtension<DraggableDialogThemeData>? other,
    double t,
  ) {
    if (other is! DraggableDialogThemeData) {
      return this;
    }
    return DraggableDialogThemeData(
      headerColor: Color.lerp(headerColor, other.headerColor, t),
      contentColor: Color.lerp(contentColor, other.contentColor, t),
      footerColor: Color.lerp(footerColor, other.footerColor, t),
      titleStyle: TextStyle.lerp(titleStyle, other.titleStyle, t),
      buttonColor: Color.lerp(buttonColor, other.buttonColor, t),
      buttonStyle: ButtonStyle.lerp(buttonStyle, other.buttonStyle, t),
      buttonTextStyle:
          TextStyle.lerp(buttonTextStyle, other.buttonTextStyle, t),
      headerHeight: lerpDouble(headerHeight, other.headerHeight, t),
      footerHeight: lerpDouble(footerHeight, other.footerHeight, t),
      buttonHeight: lerpDouble(buttonHeight, other.buttonHeight, t),
      buttonMinWidth: lerpDouble(buttonMinWidth, other.buttonMinWidth, t),
      buttonTextSize: lerpDouble(buttonTextSize, other.buttonTextSize, t),
      headerTextSize: lerpDouble(headerTextSize, other.headerTextSize, t),
      closeIconSize: lerpDouble(closeIconSize, other.closeIconSize, t),
      closeIconColor: Color.lerp(closeIconColor, other.closeIconColor, t),
      shape: ShapeBorder.lerp(shape, other.shape, t),
      elevation: lerpDouble(elevation, other.elevation, t),
      minWidth: lerpDouble(minWidth, other.minWidth, t),
      minHeight: lerpDouble(minHeight, other.minHeight, t),
    );
  }

  /// Creates a default theme for the dialog based on the current [ThemeData].
  ///
  /// When [ThemeData.extensions] contains a [DraggableDialogThemeData], its
  /// non-null fields replace the built-in light or dark values.
  factory DraggableDialogThemeData.from(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final base = isDarkMode
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

    final themeExtension = theme.extension<DraggableDialogThemeData>();
    if (themeExtension == null) {
      return base;
    }
    return base.copyWith(
      headerColor: themeExtension.headerColor,
      contentColor: themeExtension.contentColor,
      footerColor: themeExtension.footerColor,
      titleStyle: themeExtension.titleStyle,
      buttonColor: themeExtension.buttonColor,
      buttonStyle: themeExtension.buttonStyle,
      buttonTextStyle: themeExtension.buttonTextStyle,
      headerHeight: themeExtension.headerHeight,
      footerHeight: themeExtension.footerHeight,
      buttonHeight: themeExtension.buttonHeight,
      buttonMinWidth: themeExtension.buttonMinWidth,
      buttonTextSize: themeExtension.buttonTextSize,
      headerTextSize: themeExtension.headerTextSize,
      closeIconSize: themeExtension.closeIconSize,
      closeIconColor: themeExtension.closeIconColor,
      shape: themeExtension.shape,
      elevation: themeExtension.elevation,
      minWidth: themeExtension.minWidth,
      minHeight: themeExtension.minHeight,
    );
  }
}

/// A highly customizable dialog widget with a draggable header.
///
/// This widget provides a structured layout with a header, content, and footer,
/// each of which can be replaced with a custom widget.
class DraggableDialog extends StatefulWidget {
  /// The widget to display in the header. If null, the header is not shown.
  ///
  /// When [dragEntireHeader] is true, the header container is the drag target.
  final Widget? header;

  /// When true, a pan on the header container drags the dialog.
  ///
  /// When false, the header is not wrapped in a [GestureDetector]. Place
  /// [onDragUpdate] on the part of [header] that should drag.
  final bool dragEntireHeader;

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
  /// When null, a [DialogFooter] keeps its own icon and any other footer uses
  /// [Icons.drag_handle].
  final IconData? resizeHandleIcon;

  /// Size of the resize handle icon when [resizable] is enabled.
  ///
  /// When null, a [DialogFooter] keeps its own size and any other footer uses
  /// [DraggableDialogThemeData.buttonTextSize] or 18.
  final double? resizeHandleIconSize;

  const DraggableDialog({
    super.key,
    required this.body,
    required this.onDragUpdate,
    this.header,
    this.dragEntireHeader = true,
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
    final provided = ResizeHandleProvider.leftOf(context);
    if (provided != null) {
      provided(details);
      return;
    }
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final dialogTheme =
            widget.theme ?? DraggableDialogThemeData.from(context);
        final screenHeight = MediaQuery.of(context).size.height;
        final baseWidth = constraints.hasTightWidth
            ? constraints.maxWidth
            : widget.width ?? 400.0;
        final baseHeight = constraints.hasTightHeight
            ? constraints.maxHeight
            : widget.height ?? widget.maxHeight ?? screenHeight * 0.85;

        final maxWidth =
            constraints.hasBoundedWidth && constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : double.infinity;
        final maxHeight =
            constraints.hasBoundedHeight && constraints.maxHeight.isFinite
                ? constraints.maxHeight
                : screenHeight;

        final effectiveWidth = (baseWidth + _widthOffset).clamp(
          dialogTheme.minWidth ?? 200.0,
          maxWidth,
        );
        final effectiveHeight = (baseHeight + _heightOffset).clamp(
          dialogTheme.minHeight ?? 150.0,
          maxHeight,
        );

        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: effectiveHeight),
          child: Material(
            elevation: dialogTheme.elevation ?? 4.0,
            shape: dialogTheme.shape ??
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
            clipBehavior: Clip.antiAlias,
            child: SizedBox(
              width: effectiveWidth,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (widget.header != null) _buildHeader(dialogTheme),
                  _buildBody(dialogTheme),
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
      },
    );
  }

  Widget _buildHeader(DraggableDialogThemeData dialogTheme) {
    final coloredHeader = Container(
      height: dialogTheme.headerHeight,
      color: dialogTheme.headerColor,
      child: widget.header,
    );
    if (!widget.dragEntireHeader) {
      return coloredHeader;
    }
    return GestureDetector(
      onPanUpdate: widget.onDragUpdate,
      child: coloredHeader,
    );
  }

  Widget _buildBody(DraggableDialogThemeData dialogTheme) {
    if (!widget.scrollable) {
      final content =
          Material(color: dialogTheme.contentColor, child: widget.body);
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
    if (!widget.resizable) {
      return footerWidget;
    }

    if (footerWidget is DialogFooter) {
      return DialogFooter(
        onOk: footerWidget.onOk,
        onCancel: footerWidget.onCancel,
        okText: footerWidget.okText,
        cancelText: footerWidget.cancelText,
        theme: footerWidget.theme,
        onResizeUpdate: _handleResize,
        resizeHandleIcon:
            widget.resizeHandleIcon ?? footerWidget.resizeHandleIcon,
        resizeHandleIconSize:
            widget.resizeHandleIconSize ?? footerWidget.resizeHandleIconSize,
      );
    }

    return Row(
      children: [
        _ResizeHandle(
          onResizeUpdate: _handleResize,
          icon: widget.resizeHandleIcon ?? Icons.drag_handle,
          size: widget.resizeHandleIconSize ?? dialogTheme.buttonTextSize ?? 18,
          color: dialogTheme.buttonColor?.withValues(alpha: 0.5) ?? Colors.grey,
        ),
        Expanded(child: footerWidget),
      ],
    );
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
      effectiveButtonStyle =
          (effectiveButtonStyle ?? const ButtonStyle()).copyWith(
        minimumSize: WidgetStateProperty.all(
          Size(theme.buttonMinWidth ?? 0, theme.buttonHeight ?? 0),
        ),
      );
    }
    if (theme.buttonColor != null) {
      effectiveButtonStyle =
          (effectiveButtonStyle ?? const ButtonStyle()).copyWith(
        backgroundColor: WidgetStateProperty.all(theme.buttonColor),
      );
    }

    // Resolve button text style with text size
    TextStyle? effectiveButtonTextStyle = theme.buttonTextStyle;
    if (theme.buttonTextSize != null) {
      effectiveButtonTextStyle =
          (effectiveButtonTextStyle ?? const TextStyle()).copyWith(
        fontSize: theme.buttonTextSize,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          if (onResizeUpdate != null)
            _ResizeHandle(
              onResizeUpdate: onResizeUpdate!,
              icon: resizeHandleIcon,
              size: resizeHandleIconSize ?? theme.buttonTextSize ?? 18,
              color: theme.buttonColor?.withValues(alpha: 0.5) ?? Colors.grey,
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

class _ResizeHandle extends StatelessWidget {
  const _ResizeHandle({
    required this.onResizeUpdate,
    required this.icon,
    required this.size,
    required this.color,
  });

  final void Function(DragUpdateDetails) onResizeUpdate;
  final IconData icon;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: onResizeUpdate,
      child: MouseRegion(
        cursor: SystemMouseCursors.resizeDownRight,
        child: Icon(icon, size: size, color: color),
      ),
    );
  }
}
