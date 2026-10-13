## 0.2.0

* **BREAKING**: `showDraggableDialogWithBuilder` positions the dialog with pixel `Offset`s instead of `Dialog.alignment`. Drag and resize stay 1:1 with the pointer, including when dialog content is scaled.
* **FEATURE**: `ResizeHandleProvider` exposes drag, left resize, right resize, and content-height callbacks to custom chrome.
* **FEATURE**: `showDraggableDialogWithBuilder` takes optional `intrinsicHeight` and `onResizeUpdate`.
* **FEATURE**: The route clamps to view padding, view insets, and `insetPadding`, and shrinks an oversized dialog to fit.
* **FIX**: `showLegacyDraggableDialog` forwards `height` to `DraggableDialog`.

## 0.1.2

* **FEATURE**: `DraggableDialogThemeData` now extends `ThemeExtension`. Add it to `ThemeData.extensions`. `DraggableDialogThemeData.from` overlays that extension, and null fields keep the built-in light and dark values.
* **FEATURE**: Add optional theme fields `shape`, `elevation`, `minWidth`, and `minHeight`.
* **FEATURE**: `showLegacyDraggableDialog` and `showDraggableDialogWithBuilder` take optional `useRootNavigator`, `routeSettings`, and `transitionBuilder`.
* **FEATURE**: `showLegacyDraggableDialog` takes optional `scrollable`, `resizable`, `resizeHandleIcon`, `resizeHandleIconSize`, and `showHeader`.
* **FEATURE**: `DraggableDialog` takes `dragEntireHeader`. The default header drags from the title, so the close button no longer moves the dialog. Custom headers still drag as a whole.
* **FEATURE**: `resizable` adds a resize handle for any footer, including footers that are not a `DialogFooter`.
* **DEPRECATION**: On `showLegacyDraggableDialog`, `headerHeight`, `footerHeight`, `buttonHeight`, `buttonMinWidth`, `buttonTextSize`, `headerTextSize`, `closeIconSize`, `titleStyle`, `closeIconColor`, and `buttonColor` are deprecated. Set them on `DraggableDialogThemeData`. A non-null argument still overrides `theme`.

## 0.1.1

* **FIX**: Replace deprecated `Color.withOpacity` with `withValues` for the resize handle icon.

## 0.1.0

* **FEATURE**: Add optional dialog resizing via a footer drag handle (`resizable`, `resizeHandleIcon`, `resizeHandleIconSize`).
* **FEATURE**: Add `DraggableDialog.height` and expand `DraggableDialogThemeData` with sizing and styling options (`headerHeight`, `footerHeight`, `buttonHeight`, `buttonMinWidth`, `buttonTextSize`, `headerTextSize`, `closeIconSize`, `closeIconColor`, `buttonColor`) plus `copyWith`.
* **FEATURE**: Add `scrollable` on `DraggableDialog` to control body scrolling (defaults to `true`) with an integrated scrollbar.
* **FEATURE**: Extend `showLegacyDraggableDialog` with the new theme sizing and styling parameters; improve the default header layout (centered, ellipsis, configurable close icon).
* **FIX**: Use theme-derived button colors instead of a hardcoded default button background.

## 0.0.3

* **FIX**: Fix the drag math when the dialog is smaller than the default dimensions.
* **FIX**: Fix the test asset loading issue in `lib/draggable_dialog.dart`.

## 0.0.2

* **FIX**: Fix some formatting issues and add more complete description to the pubspec.yaml file.

## 0.0.1

* **FEATURE**: Initial release