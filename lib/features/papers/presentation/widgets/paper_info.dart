import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/route_names.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../common/widgets/tag_chip.dart';
import '../../../home/domain/entities/paper_entity.dart';
import '../../../library/presentation/cubit/library_cubit.dart';
import 'latex_renderer.dart';
import 'my_text_icon.dart';

class PaperInfo extends StatefulWidget {
  final PaperEntity paper;
  final VoidCallback? onSavePressed;

  const PaperInfo({super.key, required this.paper, this.onSavePressed});

  @override
  State<PaperInfo> createState() => _PaperInfoState();
}

class _PaperInfoState extends State<PaperInfo> {
  bool _showAllAuthors = false;

  String get _publishedYear {
    return widget.paper.publishedAt.year.toString();
  }

  String get _authorsText {
    if (widget.paper.authors.isEmpty) return 'Unknown authors';
    return widget.paper.authors.join(', ');
  }

  String get _authorsPreview {
    if (widget.paper.authors.isEmpty) return 'Unknown authors';
    if (widget.paper.authors.length <= 4) return _authorsText;
    return '${widget.paper.authors.take(4).join(', ')}...';
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = context.titleLarge;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LaTeXRenderer(text: widget.paper.title, textStyle: titleStyle),
        SizedBox(height: MySizes.spaceXs(context)),
        RichText(
          text: TextSpan(
            style: context.titleSmall.copyWith(
              color: MyColors.primaryShade900,
              fontSize: 16,
              fontFamily: GoogleFonts.sourceSerif4().fontFamily,
              fontWeight: FontWeight.w400,
            ),
            children: [
              TextSpan(text: _showAllAuthors ? _authorsText : _authorsPreview),
              if (widget.paper.authors.length > 4) const TextSpan(text: ' '),
              if (widget.paper.authors.length > 4)
                WidgetSpan(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _showAllAuthors = !_showAllAuthors;
                      });
                    },
                    child: Text(
                      _showAllAuthors ? 'Show less' : 'Show all authors',
                      style: context.titleSmall.copyWith(
                        color: MyColors.primaryShade900,
                        fontSize: 16,
                        fontFamily: GoogleFonts.sourceSerif4().fontFamily,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: MySizes.spaceXs(context)),
        Row(
          children: [
            Text(
              "preprint",
              style: context.labelSmall.copyWith(
                color: MyColors.warning,
                fontSize: 12,
                fontFamily: GoogleFonts.sourceSerif4().fontFamily,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: MySizes.spaceXs(context)),
            Text(
              '• $_publishedYear',
              style: context.labelSmall.copyWith(
                color: MyColors.primaryShade900,
                fontSize: 12,
                fontFamily: GoogleFonts.sourceSerif4().fontFamily,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: MySizes.spaceXs(context)),
            Text(
              '• Open Access',
              style: context.labelSmall.copyWith(
                color: MyColors.success,
                fontSize: 12,
                fontFamily: GoogleFonts.sourceSerif4().fontFamily,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: MySizes.spaceXs(context)),
        Text(
          'ID: ${widget.paper.id}',
          style: context.labelSmall.copyWith(
            color: MyColors.primaryShade900,
            fontSize: 12,
            fontFamily: GoogleFonts.sourceSerif4().fontFamily,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: MySizes.spaceXs(context)),
        if (widget.paper.categories.isNotEmpty)
          Wrap(
            spacing: 4,
            runSpacing: 6,
            children: widget.paper.categories
                .map((category) => TagChip(label: category))
                .toList(),
          ),
        SizedBox(height: MySizes.spaceXs(context)),
        Row(
          children: [
            Expanded(
              child: MyTextButton(
                onPressed: () {
                  // Fire and forget: reading history updates in background.
                  context.read<LibraryCubit>().updataReadingHistory(
                    widget.paper.id,
                  );
                  context.push(
                    RouteNames.paperReadingRoute(widget.paper.id),
                    extra: widget.paper,
                  );
                },
                title: 'Read',
                titleColor: MyColors.primaryShade900,
                buttonColor: MyColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    MySizes.borderRadiusLg(context),
                  ),
                  side: BorderSide(color: MyColors.primaryShade700),
                ),
              ),
            ),
            SizedBox(width: MySizes.spaceXs(context)),
            Expanded(
              child: MyTextButton(
                title: widget.paper.isSaved ? 'Saved' : 'Save',
                titleColor: MyColors.white,
                buttonColor: MyColors.primaryShade800,
                onPressed: () {
                  widget.onSavePressed?.call();
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    MySizes.borderRadiusLg(context),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
