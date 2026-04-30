/// Highlight Actions Sheet Widget
///
/// Bottom sheet for editing existing highlights
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mirath/core/helpers/responsive_helper.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/paper_annotations/domain/entites/highlight_entity.dart';
import 'package:mirath/features/paper_annotations/presentation/utils/annotation_theme_colors.dart';
import 'package:mirath/generated/l10n.dart';

class HighlightActionsSheet extends StatelessWidget {
  final Highlight highlight;
  final Function(String color) onColorChange;
  final VoidCallback onAddNote;
  final VoidCallback onDelete;

  const HighlightActionsSheet({
    super.key,
    required this.highlight,
    required this.onColorChange,
    required this.onAddNote,
    required this.onDelete,
  });

  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }

  String _normalizeColorHex(String value) {
    final clean = value.replaceAll('#', '').toUpperCase();
    if (clean.length == 6) return clean;
    if (clean.length == 8) return clean.substring(2);
    return 'FFE082';
  }

  String _localizedColorName(BuildContext context, String name) {
    switch (name.toLowerCase()) {
      case 'yellow':
        return S.of(context).yellow_color;
      case 'green':
        return S.of(context).green_color;
      case 'blue':
        return S.of(context).blue_color;
      case 'purple':
        return S.of(context).purple_color;
      case 'red':
        return S.of(context).red_color;
      case 'cyan':
        return S.of(context).cyan_color;
      default:
        return name;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get theme-aware colors
    final brightness = MediaQuery.of(context).platformBrightness;
    final themeColors = AnnotationThemeColors.fromBrightness(brightness);
    final colors = themeColors.highlightColors;

    return Container(
      padding: MySizes.paddingMd(context),
      decoration: BoxDecoration(
        color: themeColors.backgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(MySizes.borderRadiusLg(context)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: ResponsiveHelper.responsiveValue(context, 40),
              height: ResponsiveHelper.responsiveValue(context, 4),
              margin: EdgeInsets.only(bottom: MySizes.spaceLg(context)),
              decoration: BoxDecoration(
                color: themeColors.borderColor.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.responsiveValue(context, 2),
                ),
              ),
            ),
          ),

          // Highlighted text
          Text(
            S.of(context).highlighted_text_label,
            style: context.labelSmall.copyWith(
              color: themeColors.textColor.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: MySizes.spaceSm(context)),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(MySizes.spaceSm(context)),
            decoration: BoxDecoration(
              color: _hexToColor(highlight.color).withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(
                MySizes.borderRadiusSm(context),
              ),
              border: Border.all(color: themeColors.borderColor),
            ),
            child: Text(
              highlight.selectedText,
              style: context.bodyMedium.copyWith(color: themeColors.textColor),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          SizedBox(height: MySizes.spaceLg(context)),

          // Note section
          if (highlight.note != null && highlight.note!.isNotEmpty) ...[
            Text(
              S.of(context).note_label,
              style: context.labelSmall.copyWith(
                color: themeColors.textColor.withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: MySizes.spaceSm(context)),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(MySizes.spaceSm(context)),
              decoration: BoxDecoration(
                color: themeColors.backgroundColor.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(
                  MySizes.borderRadiusSm(context),
                ),
                border: Border.all(color: themeColors.borderColor),
              ),
              child: Text(
                highlight.note!,
                style: context.bodyMedium.copyWith(
                  color: themeColors.textColor,
                ),
              ),
            ),
            SizedBox(height: MySizes.spaceLg(context)),
          ],

          // Color picker
          Text(
            S.of(context).change_color_label,
            style: context.labelSmall.copyWith(
              color: themeColors.textColor.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: MySizes.spaceSm(context)),
          Wrap(
            spacing: MySizes.spaceSm(context),
            runSpacing: MySizes.spaceSm(context),
            children: colors.map((colorData) {
              final colorHex = colorData['hex']!;
              final colorName = colorData['name']!;
              final isSelected =
                  _normalizeColorHex(colorHex) ==
                  _normalizeColorHex(highlight.color);

              return GestureDetector(
                onTap: () => onColorChange(colorHex),
                child: Column(
                  children: [
                    Container(
                      width: ResponsiveHelper.responsiveValue(context, 48),
                      height: ResponsiveHelper.responsiveValue(context, 48),
                      decoration: BoxDecoration(
                        color: _hexToColor(colorHex),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? themeColors.primaryColor
                              : themeColors.borderColor,
                          width: isSelected
                              ? ResponsiveHelper.responsiveValue(context, 3)
                              : ResponsiveHelper.responsiveValue(context, 1),
                        ),
                      ),
                      child: isSelected
                          ? Icon(
                              Icons.check,
                              color: themeColors.backgroundColor,
                              size: MySizes.iconSmall(context),
                            )
                          : null,
                    ),
                    SizedBox(
                      height: ResponsiveHelper.responsiveValue(context, 4),
                    ),
                    Text(
                      _localizedColorName(context, colorName),
                      style: context.labelSmall.copyWith(
                        color: themeColors.textColor.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          SizedBox(height: MySizes.spaceXl(context)),

          // Action buttons
          Row(
            children: [
              // Add/Edit Note
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onAddNote,
                  icon: Icon(
                    highlight.note == null || highlight.note!.isEmpty
                        ? Icons.note_add
                        : Icons.edit_note,
                    color: themeColors.primaryColor,
                  ),
                  label: Text(
                    highlight.note == null || highlight.note!.isEmpty
                        ? S.of(context).add_note_button
                        : S.of(context).edit_note_button,
                    style: TextStyle(color: themeColors.primaryColor),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: MySizes.spaceSm(context),
                    ),
                    side: BorderSide(color: themeColors.borderColor),
                  ),
                ),
              ),

              SizedBox(width: MySizes.spaceSm(context)),

              // Copy Text
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: highlight.selectedText),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(S.of(context).copied_to_clipboard),
                        backgroundColor: themeColors.primaryColor,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: Icon(Icons.copy, color: themeColors.primaryColor),
                  label: Text(
                    S.of(context).copy_button,
                    style: TextStyle(color: themeColors.primaryColor),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: MySizes.spaceSm(context),
                    ),
                    side: BorderSide(color: themeColors.borderColor),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: MySizes.spaceSm(context)),

          // Delete button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    backgroundColor: themeColors.backgroundColor,
                    title: Text(
                      S.of(context).delete_highlight_title,
                      style: TextStyle(color: themeColors.textColor),
                    ),
                    content: Text(
                      S.of(context).confirm_delete_highlight,
                      style: TextStyle(color: themeColors.textColor),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: Text(
                          S.of(context).cancel_button,
                          style: TextStyle(color: themeColors.primaryColor),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                          onDelete();
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: MyColors.error,
                        ),
                        child: Text(S.of(context).delete_button),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.delete, color: MyColors.error),
              label: Text(
                S.of(context).delete_highlight_title,
                style: TextStyle(color: MyColors.error),
              ),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: MySizes.spaceSm(context),
                ),
                side: const BorderSide(color: MyColors.error),
              ),
            ),
          ),

          // Bottom padding for safe area
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
