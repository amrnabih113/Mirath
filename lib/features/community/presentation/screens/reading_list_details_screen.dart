import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../common/widgets/my_back_icon.dart';
import '../../../common/widgets/profile_avatar.dart';
import '../../../common/widgets/tag_chip.dart';

class ReadingListDetailsScreen extends StatelessWidget {
  const ReadingListDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: ResponsiveHelper.responsiveValue(context, 50),
        leadingWidth: ResponsiveHelper.responsiveValue(context, 50),
        leading: MyBackIcon(),
        titleSpacing: 0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: MySizes.spaceSm(context)),
            child: IconButton(
              onPressed: () {},
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedMoreHorizontal,
                size: MySizes.iconMedium(context),
                strokeWidth: ResponsiveHelper.responsiveValue(context, 2),
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 850),
              child: Padding(
                padding: MySizes.paddingMd(context),
                child: SafeArea(
                  bottom: false,
                  child: CustomScrollView(
                    slivers: [
                      /// USER HEADER
                      SliverToBoxAdapter(
                        child: Row(
                          children: [
                            ProfileAvatar(
                              size: ResponsiveHelper.responsiveValue(
                                context,
                                40,
                              ),
                            ),
                            SizedBox(width: MySizes.spaceSm(context)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Jane Doe',
                                    style: context.titleSmall.copyWith(
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  SizedBox(
                                    height: MySizes.spaceXs(context) * 0.5,
                                  ),
                                  Text(
                                    '3 papers • 5 saves • Updated 2 days ago',
                                    style: context.bodySmall.copyWith(
                                      color: MyColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(height: MySizes.spaceMd(context)),
                      ),

                      /// TITLE
                      SliverToBoxAdapter(
                        child: Text(
                          'Introduction to CNN',
                          style: context.titleSmall.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(height: MySizes.spaceSm(context)),
                      ),

                      /// DESCRIPTION
                      SliverToBoxAdapter(
                        child: ExpandableText(
                          text:
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi egestas ex in mi ultrices tincidunt. Sed euismod, nisl eget ultricies tincidunt, nisl nisl aliquam nisl, nec aliquam nisl nisl sit amet nisl.',
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(height: MySizes.spaceMd(context)),
                      ),

                      /// TAGS
                      SliverToBoxAdapter(
                        child: Wrap(
                          spacing: MySizes.spaceXs(context),
                          runSpacing: MySizes.spaceXs(context) * 0.5,
                          children: const [
                            TagChip(label: 'Artificial Intelligence'),
                            TagChip(label: 'CNN'),
                            TagChip(label: 'Machine Learning'),
                            TagChip(label: 'Computer Vision'),
                          ],
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(height: MySizes.spaceMd(context)),
                      ),

                      /// SAVE BUTTON
                      SliverToBoxAdapter(
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text('Save Full List'),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(height: MySizes.spaceLg(context)),
                      ),

                      /// PAPERS LIST
                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: MySizes.spaceMd(context),
                            ),
                            child: SizedBox(),
                            // PaperCard(number: index + 1),
                          );
                        }, childCount: 3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ExpandableText extends StatefulWidget {
  const ExpandableText({super.key, required this.text});
  final String text;

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    const maxLength = 120;
    final shouldTruncate = widget.text.length > maxLength;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isExpanded || !shouldTruncate
              ? widget.text
              : widget.text.substring(0, maxLength),
          style: context.bodyMedium.copyWith(
            height: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (shouldTruncate)
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Text(
              isExpanded ? 'less' : '...more',
              style: context.bodyMedium.copyWith(
                color: MyColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}
