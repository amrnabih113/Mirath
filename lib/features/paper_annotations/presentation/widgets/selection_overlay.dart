/// Selection Overlay Widget
///
/// Floating action menu that appears when text is selected
import 'package:flutter/material.dart';
import 'package:mirath/core/helpers/responsive_helper.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/paper_annotations/presentation/utils/annotation_theme_colors.dart';

enum AnnotationDialogMode { selectionActions, selectionColors, highlightColors }

class AnnotationSelectionOverlay extends StatelessWidget {
  final SelectionPosition position;
  final AnnotationDialogMode mode;
  final ValueChanged<String> onSelectColor;
  final VoidCallback onHighlightPressed;
  final VoidCallback onNote;
  final VoidCallback onExplain;
  final VoidCallback onTranslate;
  final VoidCallback? onRemove;
  final String noteActionLabel;
  final String? selectedColor;
  final VoidCallback onDismiss;

  const AnnotationSelectionOverlay({
    super.key,
    required this.position,
    required this.mode,
    required this.onSelectColor,
    required this.onHighlightPressed,
    required this.onNote,
    required this.onExplain,
    required this.onTranslate,
    this.onRemove,
    this.noteActionLabel = 'Add Note',
    this.selectedColor,
    required this.onDismiss,
  });

  Color _hexToColor(String hex) {
    var cleanedHex = hex.replaceAll('#', '');
    if (cleanedHex.length == 6) {
      cleanedHex = 'FF$cleanedHex';
    }
    return Color(int.parse(cleanedHex, radix: 16));
  }

  List<Map<String, String>> _buildDialogColors(
    List<Map<String, String>> source,
  ) {
    final desiredOrder = <String>['Yellow', 'Green', 'Cyan', 'Purple', 'Red'];
    final ordered = <Map<String, String>>[];

    for (final name in desiredOrder) {
      final found = source.where((entry) => entry['name'] == name);
      if (found.isNotEmpty) {
        ordered.add(found.first);
      }
    }

    if (ordered.length == desiredOrder.length) {
      return ordered;
    }

    return source.take(5).toList();
  }

  String _normalizeColor(String color) {
    final clean = color.replaceAll('#', '').toUpperCase();
    if (clean.length == 6) return '#$clean';
    if (clean.length == 8) return '#${clean.substring(2)}';
    return '#FFE082';
  }

  double _menuWidth(BuildContext context, AnnotationDialogMode mode) {
    switch (mode) {
      case AnnotationDialogMode.selectionActions:
        return ResponsiveHelper.responsiveValue(context, 300);
      case AnnotationDialogMode.selectionColors:
        return ResponsiveHelper.responsiveValue(context, 250);
      case AnnotationDialogMode.highlightColors:
        return ResponsiveHelper.responsiveValue(context, 320);
    }
  }

  double _menuHeight(BuildContext context, AnnotationDialogMode mode) {
    switch (mode) {
      case AnnotationDialogMode.selectionActions:
        return ResponsiveHelper.responsiveValue(context, 40);
      case AnnotationDialogMode.selectionColors:
      case AnnotationDialogMode.highlightColors:
        return ResponsiveHelper.responsiveValue(context, 40);
    }
  }

  Widget _buildDivider(BuildContext context, Color color, {double? height}) {
    return Container(
      width: ResponsiveHelper.responsiveValue(context, 1),
      height: height ?? ResponsiveHelper.responsiveValue(context, 24),
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.responsiveValue(context, 0),
      ),
      color: color,
    );
  }

  Widget _buildActionItem({
    required BuildContext context,
    required String label,
    required VoidCallback onTap,
    required Color color,
    FontWeight weight = FontWeight.w400,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(MySizes.borderRadiusSm(context)),
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MySizes.spaceXs(context),
          vertical: ResponsiveHelper.responsiveValue(context, 4),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: MySizes.bodyMedium(context),
            fontWeight: weight,
            height: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildColorCircle({
    required BuildContext context,
    required String hex,
    required VoidCallback onTap,
    required Color borderColor,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: ResponsiveHelper.responsiveValue(context, 42),
        height: ResponsiveHelper.responsiveValue(context, 42),
        decoration: BoxDecoration(
          color: _hexToColor(hex),
          shape: BoxShape.circle,
          border: Border.all(
            color: borderColor,
            width: isSelected
                ? ResponsiveHelper.responsiveValue(context, 1)
                : 0,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuContent(
    BuildContext context,
    AnnotationThemeColors themeColors,
  ) {
    final separator = themeColors.borderColor.withValues(alpha: 0.35);
    final colors = _buildDialogColors(themeColors.highlightColors);

    if (mode == AnnotationDialogMode.selectionActions) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildActionItem(
            context: context,
            label: 'Highlight',
            onTap: onHighlightPressed,
            color: MyColors.black,
          ),
          _buildDivider(context, separator),
          _buildActionItem(
            context: context,
            label: noteActionLabel,
            onTap: onNote,
            color: MyColors.black,
          ),
          _buildDivider(context, separator),
          _buildActionItem(
            context: context,
            label: 'Explain',
            onTap: onExplain,
            color: MyColors.black,
          ),
          _buildDivider(context, separator),
          _buildActionItem(
            context: context,
            label: 'Translate',
            onTap: onTranslate,
            color: MyColors.black,
          ),
        ],
      );
    }

    final normalizedSelected = selectedColor == null
        ? null
        : _normalizeColor(selectedColor!);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < colors.length; i++) ...[
          _buildColorCircle(
            context: context,
            hex: colors[i]['hex']!,
            onTap: () => onSelectColor(colors[i]['hex']!),
            borderColor: separator,
            isSelected:
                normalizedSelected != null &&
                normalizedSelected == _normalizeColor(colors[i]['hex']!),
          ),
          if (i != colors.length - 1)
            _buildDivider(
              context,
              separator,
              height: ResponsiveHelper.responsiveValue(context, 30),
            ),
        ],
        if (mode == AnnotationDialogMode.highlightColors &&
            onRemove != null) ...[
          _buildDivider(
            context,
            separator,
            height: ResponsiveHelper.responsiveValue(context, 30),
          ),
          _buildActionItem(
            context: context,
            label: noteActionLabel,
            onTap: onNote,
            color: MyColors.black,
          ),
          _buildDivider(
            context,
            separator,
            height: ResponsiveHelper.responsiveValue(context, 30),
          ),
          _buildActionItem(
            context: context,
            label: 'Remove',
            onTap: onRemove!,
            color: Colors.red,
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final themeColors = AnnotationThemeColors.fromBrightness(brightness);

    final screenSize = MediaQuery.of(context).size;
    final menuWidth = _menuWidth(context, mode);
    final menuHeight = _menuHeight(context, mode);

    double left = position.x;
    double top =
        position.y - menuHeight - ResponsiveHelper.responsiveValue(context, 12);

    final screenPadding = ResponsiveHelper.responsiveValue(context, 12);

    if (left + menuWidth > screenSize.width - screenPadding) {
      left = screenSize.width - menuWidth - screenPadding;
    }
    if (left < screenPadding) {
      left = screenPadding;
    }

    if (top < ResponsiveHelper.responsiveValue(context, 16)) {
      top =
          position.y +
          position.height +
          ResponsiveHelper.responsiveValue(context, 10);
    }

    final maxTop = screenSize.height - menuHeight - screenPadding;
    if (top > maxTop) {
      top = maxTop;
    }

    if (top < screenPadding) {
      top = screenPadding;
    }

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: onDismiss,
            behavior: HitTestBehavior.translucent,
            child: Container(color: Colors.transparent),
          ),
        ),
        Positioned(
          left: left,
          top: top,
          child: Container(
            width: menuWidth,
            height: menuHeight,
            padding: EdgeInsets.symmetric(
              horizontal: MySizes.spaceSm(context),
              vertical: MySizes.spaceXs(context),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                MySizes.borderRadiusLg(context) * 20,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: ResponsiveHelper.responsiveValue(context, 18),
                  offset: Offset(
                    0,
                    ResponsiveHelper.responsiveValue(context, 6),
                  ),
                ),
              ],
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _buildMenuContent(context, themeColors),
            ),
          ),
        ),
      ],
    );
  }
}

class SelectionPosition {
  final double x;
  final double y;
  final double width;
  final double height;

  const SelectionPosition({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SelectionPosition &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y &&
          width == other.width &&
          height == other.height;

  @override
  int get hashCode =>
      x.hashCode ^ y.hashCode ^ width.hashCode ^ height.hashCode;
}
