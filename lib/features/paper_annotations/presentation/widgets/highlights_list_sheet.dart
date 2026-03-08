import 'package:flutter/material.dart';
import 'package:mirath/core/helpers/responsive_helper.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/paper_annotations/presentation/widgets/annotation_equation_preview.dart';
import '../../domain/entites/highlight_entity.dart';

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
    return Material(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: MySizes.spaceMd(context)),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                0,
                MySizes.spaceMd(context),
                0,
                MySizes.spaceSm(context),
              ),
              child: Row(
                children: [
                  MyBackIcon(onTap: () => Navigator.of(context).pop()),
                  Expanded(
                    child: Text(
                      'Highlights',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
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
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                      ),
                    )
                  : ListView.separated(
                      controller: scrollController,
                      padding: EdgeInsets.symmetric(
                        horizontal: MySizes.spaceMd(context),
                        vertical: MySizes.spaceSm(context),
                      ),
                      itemCount: highlights.length,
                      separatorBuilder: (_, __) => Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: MySizes.spaceMd(context),
                        ),
                        child: Divider(
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
                              textStyle: Theme.of(
                                context,
                              ).textTheme.titleSmall?.copyWith(height: 1.35),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
