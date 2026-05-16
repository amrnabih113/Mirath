import 'package:flutter/material.dart';

import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../common/widgets/my_back_icon.dart';
import '../../domain/entites/highlight_entity.dart';
import 'annotation_equation_preview.dart';

class HighlightsListSheet extends StatelessWidget {
  final List<Highlight> highlights;
  final ScrollController? scrollController;

  const HighlightsListSheet({
    super.key,
    required this.highlights,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
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
                    'Highlights',
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
            child: highlights.isEmpty
                ? Center(
                    child: Text(
                      'No highlights yet',
                      style: context.bodyLarge.copyWith(color: Colors.grey),
                    ),
                  )
                : ListView.separated(
                    controller: scrollController,
                    padding: EdgeInsets.symmetric(
                      horizontal: MySizes.spaceMd(context),
                      vertical: MySizes.spaceSm(context),
                    ),
                    itemCount: highlights.length,
                    separatorBuilder: (_, _) => Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: MySizes.spaceMd(context),
                      ),
                      child: Divider(
                        color: MyColors.primaryShade300,
                        height: ResponsiveHelper.responsiveValue(context, 1),
                      ),
                    ),
                    itemBuilder: (context, index) {
                      final highlight = highlights[index];
                      return InkWell(
                        onTap: () => Navigator.of(context).pop(highlight),
                        borderRadius: BorderRadius.circular(
                          MySizes.borderRadiusSm(context),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: MySizes.spaceXs(context),
                          ),
                          child: AnnotationEquationPreview(
                            text: highlight.selectedText,
                            htmlContent: highlight.htmlContent,
                            highlightColorHex: highlight.color,
                            maxLines: 2,
                            textStyle: context.titleSmall.copyWith(
                              height: 1.35,
                            ),
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
