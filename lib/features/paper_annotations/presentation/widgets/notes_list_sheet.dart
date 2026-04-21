import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/helpers/responsive_helper.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/paper_annotations/presentation/widgets/annotation_equation_preview.dart';
import '../../domain/entites/highlight_entity.dart';

enum NotesListSheetAction { focus, edit }

class NotesListSheetResult {
  final Highlight highlight;
  final NotesListSheetAction action;

  const NotesListSheetResult({required this.highlight, required this.action});
}

class NotesListSheet extends StatelessWidget {
  final List<Highlight> highlights;
  final ScrollController? scrollController;

  const NotesListSheet({
    super.key,
    required this.highlights,
    this.scrollController,
  });

  List<Highlight> get _highlightsWithNotes =>
      highlights.where((h) => h.note?.isNotEmpty == true).toList();

  @override
  Widget build(BuildContext context) {
    final notesCount = _highlightsWithNotes.length;

    return Padding(
      padding: MySizes.paddingSm(context),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsetsGeometry.symmetric(
              vertical: MySizes.spaceMd(context),
              horizontal: MySizes.spaceSm(context),
            ),
            child: Row(
              children: [
                MyBackIcon(padding: false),
                Expanded(
                  child: Text(
                    'Notes',
                    textAlign: TextAlign.center,
                    style: context.titleLarge,
                  ),
                ),
                SizedBox(
                  width: MySizes.spaceXl(context) + MySizes.spaceSm(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: notesCount == 0
                ? Center(
                    child: Text(
                      'No notes yet',
                      style: context.bodyLarge.copyWith(color: Colors.grey),
                    ),
                  )
                : ListView.separated(
                    controller: scrollController,
                    padding: EdgeInsets.symmetric(
                      horizontal: MySizes.spaceMd(context),
                      vertical: MySizes.spaceSm(context),
                    ),
                    itemCount: _highlightsWithNotes.length,
                    separatorBuilder: (_, __) => Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: MySizes.spaceMd(context),
                      ),
                      child: Divider(
                        color: MyColors.primaryShade300,
                        height: ResponsiveHelper.responsiveValue(context, 1),
                      ),
                    ),
                    itemBuilder: (context, index) {
                      final highlight = _highlightsWithNotes[index];
                      return InkWell(
                        borderRadius: BorderRadius.circular(
                          MySizes.borderRadiusSm(context),
                        ),
                        onTap: () => Navigator.of(context).pop(
                          NotesListSheetResult(
                            highlight: highlight,
                            action: NotesListSheetAction.focus,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: MySizes.spaceXs(context),
                          ),
                          child: Stack(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  right: MySizes.spaceXl(context),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AnnotationEquationPreview(
                                      text: highlight.selectedText,
                                      htmlContent: highlight.htmlContent,
                                      highlightColorHex: highlight.color,
                                      maxLines: 2,
                                      textStyle: context.titleSmall.copyWith(
                                        height: 1.2,
                                      ),
                                    ),
                                    SizedBox(height: MySizes.spaceMd(context)),
                                    Text(
                                      highlight.note!,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: context.bodyLarge.copyWith(
                                        height: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                right: -MySizes.spaceSm(context),

                                child: IconButton(
                                  onPressed: () => Navigator.of(context).pop(
                                    NotesListSheetResult(
                                      highlight: highlight,
                                      action: NotesListSheetAction.edit,
                                    ),
                                  ),
                                  tooltip: 'Edit note',
                                  icon: HugeIcon(
                                    icon: HugeIcons.strokeRoundedEdit01,
                                    size: MySizes.iconSmall(context),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
