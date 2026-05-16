import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../common/widgets/my_back_icon.dart';
import '../../domain/entites/highlight_entity.dart';
import 'annotation_equation_preview.dart';

enum NotesListSheetAction { focus, edit }

class NotesListSheetResult {
  final Highlight highlight;
  final NotesListSheetAction action;

  const NotesListSheetResult({required this.highlight, required this.action});
}

class NotesListSheet extends StatefulWidget {
  final List<Highlight> highlights;
  final ScrollController? scrollController;
  final VoidCallback? onLoadMore;
  final bool isLoadingMore;
  final bool hasMore;

  const NotesListSheet({
    super.key,
    required this.highlights,
    this.scrollController,
    this.onLoadMore,
    this.isLoadingMore = false,
    this.hasMore = false,
  });

  @override
  State<NotesListSheet> createState() => _NotesListSheetState();
}

class _NotesListSheetState extends State<NotesListSheet> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.dispose();
    } else {
      _scrollController.removeListener(_onScroll);
    }
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 500 &&
        widget.hasMore &&
        !widget.isLoadingMore &&
        widget.onLoadMore != null) {
      widget.onLoadMore!();
    }
  }

  List<Highlight> get _highlightsWithNotes =>
      widget.highlights.where((h) => h.note?.isNotEmpty == true).toList();

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
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(
                      horizontal: MySizes.spaceMd(context),
                      vertical: MySizes.spaceSm(context),
                    ),
                    itemCount:
                        _highlightsWithNotes.length + (widget.hasMore ? 1 : 0),
                    separatorBuilder: (_, index) {
                      if (index >= _highlightsWithNotes.length)
                        return SizedBox.shrink();
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: MySizes.spaceMd(context),
                        ),
                        child: Divider(
                          color: MyColors.primaryShade300,
                          height: ResponsiveHelper.responsiveValue(context, 1),
                        ),
                      );
                    },
                    itemBuilder: (context, index) {
                      // Show loading indicator at the end
                      if (index >= _highlightsWithNotes.length) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: MySizes.spaceMd(context),
                          ),
                          child: Center(
                            child: widget.isLoadingMore
                                ? SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : SizedBox.shrink(),
                          ),
                        );
                      }

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
