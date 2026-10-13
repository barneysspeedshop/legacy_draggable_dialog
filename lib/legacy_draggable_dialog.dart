import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:legacy_draggable_dialog/draggable_dialog.dart';

export 'package:legacy_draggable_dialog/draggable_dialog.dart'
    show DragUpdateCallback, ResizeHandleProvider;

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
    width: width ?? 400,
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
        height: height,
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
/// Position is stored in pixels so drag and resize stay 1:1 with the pointer,
/// including when the dialog content is scaled. The builder receives an
/// `onDragUpdate` handler for the drag handle. Custom chrome can also read
/// [ResizeHandleProvider] for left/right resize and content-height reporting.
Future<T?> showDraggableDialogWithBuilder<T>({
  required BuildContext context,
  required Widget Function(
          BuildContext context, void Function(DragUpdateDetails) onDragUpdate)
      builder,
  void Function(DragUpdateDetails)? onResizeUpdate,
  double? width,
  double? height,
  Alignment initialAlignment = Alignment.center,
  bool barrierDismissible = true,
  Color barrierColor = Colors.black54,
  bool intrinsicHeight = false,
  EdgeInsets insetPadding = const EdgeInsets.all(10.0),
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  RouteTransitionsBuilder? transitionBuilder,
}) {
  return showGeneralDialog<T>(
    context: context,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    transitionBuilder: transitionBuilder,
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: barrierColor,
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      return _PixelDraggableDialogContent(
        initialWidth: width ?? (MediaQuery.of(dialogContext).size.width * 0.8),
        initialHeight: height,
        initialAlignment: initialAlignment,
        builder: builder,
        onResizeUpdate: onResizeUpdate,
        intrinsicHeight: intrinsicHeight,
        insetPadding: insetPadding,
      );
    },
  );
}

class _PixelDraggableDialogContent extends StatefulWidget {
  final Widget Function(
    BuildContext context,
    void Function(DragUpdateDetails) onDragUpdate,
  ) builder;
  final void Function(DragUpdateDetails)? onResizeUpdate;
  final double initialWidth;
  final double? initialHeight;
  final Alignment initialAlignment;
  final bool intrinsicHeight;
  final EdgeInsets insetPadding;

  const _PixelDraggableDialogContent({
    required this.initialWidth,
    this.initialHeight,
    required this.initialAlignment,
    required this.builder,
    this.onResizeUpdate,
    this.intrinsicHeight = false,
    required this.insetPadding,
  });

  @override
  State<_PixelDraggableDialogContent> createState() =>
      _PixelDraggableDialogContentState();
}

class _PixelDraggableDialogContentState
    extends State<_PixelDraggableDialogContent> {
  Offset? _position;
  final GlobalKey _dialogKey = GlobalKey();
  Size _measuredSize = Size.zero;
  Size? _requestedSize;
  Size _viewport = Size.zero;
  bool _sizeSyncScheduled = false;
  double? _contentHeight;

  void _handleContentHeightChanged(double? height) {
    if (!mounted || height == _contentHeight) return;
    setState(() => _contentHeight = height);
  }

  Offset _clampPosition(Offset position, Size size) => Offset(
        position.dx.clamp(0.0, math.max(0.0, _viewport.width - size.width)),
        position.dy.clamp(0.0, math.max(0.0, _viewport.height - size.height)),
      );

  void _scheduleSizeSync() {
    if (_sizeSyncScheduled) return;
    _sizeSyncScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sizeSyncScheduled = false;
      if (!mounted) return;
      final box = _dialogKey.currentContext?.findRenderObject() as RenderBox?;
      if (box == null || !box.hasSize) return;
      final size = box.size;
      final position = _position == null
          ? Offset(
              (_viewport.width - size.width) *
                  (widget.initialAlignment.x + 1) /
                  2,
              (_viewport.height - size.height) *
                  (widget.initialAlignment.y + 1) /
                  2,
            )
          : _clampPosition(_position!, size);
      if (size == _measuredSize && position == _position) return;
      setState(() {
        _measuredSize = size;
        _position = position;
      });
    });
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_position == null) return;
    setState(() {
      _position = _clampPosition(_position! + details.delta, _measuredSize);
    });
  }

  double _resizeExtent(double value, double minimum, double maximum) =>
      value.clamp(math.min(minimum, maximum), maximum);

  void _resize(DragUpdateDetails details, {required bool fromLeft}) {
    if (_position == null) return;
    final position = _position!;
    final right = position.dx + _measuredSize.width;
    final width = _resizeExtent(
      _measuredSize.width + (fromLeft ? -details.delta.dx : details.delta.dx),
      200,
      fromLeft ? right : _viewport.width - position.dx,
    );
    final height = _resizeExtent(
      _measuredSize.height + details.delta.dy,
      150,
      _viewport.height - position.dy,
    );
    setState(() {
      _requestedSize = Size(width, height);
      _measuredSize = Size(width, math.min(height, _contentHeight ?? height));
      _position = Offset(fromLeft ? right - width : position.dx, position.dy);
    });
    widget.onResizeUpdate?.call(details);
  }

  void _handleResizeUpdate(DragUpdateDetails details) =>
      _resize(details, fromLeft: false);

  void _handleResizeLeftUpdate(DragUpdateDetails details) =>
      _resize(details, fromLeft: true);

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final padding = EdgeInsets.fromLTRB(
          math.max(media.viewPadding.left, media.viewInsets.left),
          math.max(media.viewPadding.top, media.viewInsets.top),
          math.max(media.viewPadding.right, media.viewInsets.right),
          math.max(media.viewPadding.bottom, media.viewInsets.bottom),
        ) +
        widget.insetPadding;
    return Padding(
      padding: padding,
      child: LayoutBuilder(
        builder: (context, constraints) {
          _viewport = constraints.biggest;
          final width = math.min(
            _requestedSize?.width ?? widget.initialWidth,
            _viewport.width,
          );
          final preferredHeight =
              _requestedSize?.height ?? widget.initialHeight;
          final maximumHeight = math.min(
            _viewport.height,
            _contentHeight ?? double.infinity,
          );
          final height = preferredHeight == null
              ? null
              : math.min(preferredHeight, maximumHeight);
          final boundedSize = Size(
            widget.intrinsicHeight && _requestedSize == null
                ? math.min(_measuredSize.width, _viewport.width)
                : width,
            math.min(height ?? _measuredSize.height, _viewport.height),
          );
          if (_position != null) {
            _position = _clampPosition(_position!, boundedSize);
          }
          _scheduleSizeSync();
          final dialog = NotificationListener<SizeChangedLayoutNotification>(
            onNotification: (_) {
              _scheduleSizeSync();
              return false;
            },
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: width,
                maxHeight: maximumHeight,
              ),
              child: SizedBox(
                width: widget.intrinsicHeight && _requestedSize == null
                    ? null
                    : width,
                height: height,
                child: SizeChangedLayoutNotifier(
                  child: Material(
                    key: _dialogKey,
                    type: MaterialType.transparency,
                    child: ResizeHandleProvider(
                      onDragUpdate: _handleDragUpdate,
                      onResizeUpdate: _handleResizeUpdate,
                      onResizeLeftUpdate: _handleResizeLeftUpdate,
                      onContentHeightChanged: _handleContentHeightChanged,
                      child: widget.builder(context, _handleDragUpdate),
                    ),
                  ),
                ),
              ),
            ),
          );
          return Stack(
            children: [
              if (_position == null)
                Opacity(
                  opacity: 0,
                  child: Align(
                    alignment: widget.initialAlignment,
                    child: dialog,
                  ),
                )
              else
                Positioned(
                  left: _position!.dx,
                  top: _position!.dy,
                  child: dialog,
                ),
            ],
          );
        },
      ),
    );
  }
}
