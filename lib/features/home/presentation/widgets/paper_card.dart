import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:mirath/core/helpers/my_loaders.dart';
import 'package:mirath/features/common/widgets/tag_chip.dart';
import 'package:mirath/features/home/presentation/cubit/home_cubit.dart';
import 'package:mirath/features/papers/presentation/widgets/latex_renderer.dart';
import '../../domain/entities/paper_entity.dart';

import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';

class PaperCard extends StatefulWidget {
  const PaperCard({super.key, this.number, required this.paper});
  final int? number;
  final PaperEntity paper;

  @override
  State<PaperCard> createState() => _PaperCardState();
}

class _PaperCardState extends State<PaperCard> {
  late bool isBookmarked;
  @override
  void initState() {
    super.initState();
    isBookmarked = widget.paper.isSaved ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final isTopRanked = widget.number != null && widget.number! <= 3;
    return GestureDetector(
      onTap: () {
        context.push('/paper-screen', extra: widget.paper);
      },
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.responsiveValue(context, 16)),
        decoration: BoxDecoration(
          color: MyColors.white,
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.responsiveValue(context, 16),
          ),
          border: Border.all(
            color: MyColors.primaryShade500.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: MyColors.primaryShade900.withValues(alpha: 0.06),
              blurRadius: ResponsiveHelper.responsiveValue(context, 16),
              offset: Offset(0, ResponsiveHelper.responsiveValue(context, 4)),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: MyColors.primaryShade900.withValues(alpha: 0.03),
              blurRadius: ResponsiveHelper.responsiveValue(context, 8),
              offset: Offset(0, ResponsiveHelper.responsiveValue(context, 2)),
              spreadRadius: ResponsiveHelper.responsiveValue(context, -2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    if (widget.number != null) ...[
                      Text(
                        '${widget.number}.',
                        style: context.titleSmall.copyWith(
                          color: MyColors.black,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      if (isTopRanked) ...[
                        SizedBox(
                          width: ResponsiveHelper.responsiveValue(context, 4),
                        ),
                        Text(
                          '🔥',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.responsiveValue(
                              context,
                              14,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
                SizedBox(width: ResponsiveHelper.responsiveValue(context, 6)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  maxLines: 1,
                  'preprint  • ${DateTime.parse(widget.paper.publishedAt).year.toString()}',
                  style: context.bodySmall.copyWith(
                    color: MyColors.primaryShade600,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                IconButton(
                  onPressed: () {
                    final cubit = context.read<HomeCubit>();
                    if (isBookmarked) {
                      cubit.unsavePaper(widget.paper.id);
                      setState(() {
                        isBookmarked = false;
                      });
                      MyLoaders.customToast(
                        context: context,
                        message: 'Paper unsaved ',
                      );
                    } else {
                      cubit.savePaper(widget.paper.id);
                      setState(() {
                        isBookmarked = true;
                      });
                      MyLoaders.customToast(
                        context: context,
                        message: 'Paper saved ',
                      );
                    }
                  },
                  icon: Icon(
                    isBookmarked
                        ? HugeIconsSolid.bookmark02
                        : HugeIconsStroke.bookmark02,
                    color: MyColors.primaryShade700,
                    weight: 3,
                    size: ResponsiveHelper.responsiveValue(context, 20),
                  ),
                ),
              ],
            ),
            SizedBox(height: MySizes.spaceXs(context) * 0.5),

            // Text(
            //   widget.paper.title,
            //   //  maxLines: 2,
            //   style: context.titleMedium.copyWith(
            //     color: MyColors.primaryShade900,
            //     fontWeight: FontWeight.w700,
            //     height: 1.3,
            //     letterSpacing: -0.2,
            //     // overflow: TextOverflow.ellipsis,
            //   ),
            // ),
            LaTeXRenderer(
              text: widget.paper.title,
              height: ResponsiveHelper.responsiveValue(context, 60),
              textStyle: context.titleMedium.copyWith(
                color: MyColors.primaryShade900,
                fontWeight: FontWeight.w700,
                height: 1.3,
                letterSpacing: -0.2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: MySizes.spaceXs(context)),
            Text(
              widget.paper.authors.join(', '),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.bodySmall.copyWith(
                color: MyColors.primaryShade700,
                fontWeight: FontWeight.w500,
                fontSize: ResponsiveHelper.responsiveValue(context, 13),
              ),
            ),
            SizedBox(height: MySizes.spaceSm(context)),
            SizedBox(
              height: ResponsiveHelper.responsiveValue(context, 28),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: widget.paper.categories.length,
                itemBuilder: (_, index) {
                  return TagChip(label: widget.paper.categories[index]);
                },
                separatorBuilder: (_, index) => SizedBox(
                  width: ResponsiveHelper.responsiveValue(context, 8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
