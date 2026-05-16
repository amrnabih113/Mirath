import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../../generated/l10n.dart';

class ReaderActionMenu extends StatelessWidget {
  final bool isOpen;
  final VoidCallback onToggle;
  final VoidCallback onSearchTap;
  final VoidCallback onNotesTap;
  final VoidCallback onHighlightsTap;
  final VoidCallback onThemesTap;
  final int highlightCount;
  final int noteCount;

  const ReaderActionMenu({
    super.key,
    required this.isOpen,
    required this.onToggle,
    required this.onSearchTap,
    required this.onNotesTap,
    required this.onHighlightsTap,
    required this.onThemesTap,
    required this.highlightCount,
    required this.noteCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (isOpen) ...[
          _ActionButton(
            icon: HugeIcons.strokeRoundedSearch01,
            label: S.of(context).search_in_paper_button,
            onTap: onSearchTap,
          ),
          SizedBox(height: MySizes.spaceSm(context)),
          _ActionButton(
            icon: HugeIcons.strokeRoundedNote04,
            label: S.of(context).notes_button_label(noteCount),
            onTap: onNotesTap,
          ),
          SizedBox(height: MySizes.spaceSm(context)),
          _ActionButton(
            icon: HugeIcons.strokeRoundedPen01,
            label: S.of(context).highlights_button_label(highlightCount),
            onTap: onHighlightsTap,
          ),
          SizedBox(height: MySizes.spaceSm(context)),
          _ActionButton(
            icon: HugeIcons.strokeRoundedTextFont,
            label: S.of(context).font_size_button,
            onTap: onThemesTap,
          ),
          SizedBox(height: MySizes.spaceSm(context)),
        ],
        FloatingActionButton(
          onPressed: onToggle,
          shape: CircleBorder(),
          backgroundColor: MyColors.primaryShade50,
          foregroundColor: MyColors.primaryShade700,
          child: HugeIcon(
            icon: isOpen
                ? HugeIcons.strokeRoundedCancel01
                : HugeIcons.strokeRoundedMenu01,
            size: MySizes.iconSmall(context),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final List<List<dynamic>> icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: ResponsiveHelper.responsiveValue(context, 4),
      borderRadius: BorderRadius.circular(
        ResponsiveHelper.responsiveValue(context, 28),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.responsiveValue(context, 28),
        ),
        child: Container(
          width: ResponsiveHelper.responsiveValue(context, 200),
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.responsiveValue(context, 10),
            vertical: ResponsiveHelper.responsiveValue(context, 10),
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.responsiveValue(context, 28),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: ResponsiveHelper.responsiveValue(context, 8),
                offset: Offset(0, ResponsiveHelper.responsiveValue(context, 4)),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
              Spacer(),
              HugeIcon(icon: icon),
            ],
          ),
        ),
      ),
    );
  }
}
