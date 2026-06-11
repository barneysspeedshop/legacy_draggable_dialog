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