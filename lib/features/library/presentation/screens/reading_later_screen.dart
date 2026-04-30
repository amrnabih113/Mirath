import 'package:flutter/material.dart';
import 'package:mirath/core/helpers/responsive_helper.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/profile/presentation/widgets/profile_reading_list_card.dart';
import 'package:mirath/generated/l10n.dart';

class ReadingLaterScreen extends StatelessWidget {
  const ReadingLaterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: MyBackIcon()),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 850),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    height: 100,
                    width: MySizes.screenWidth(context),
                    padding: EdgeInsets.all(
                      ResponsiveHelper.responsiveValue(context, 16),
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 1,
                          color: MyColors.primaryShade100,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).read_later,
                          style: context.headlineSmall.copyWith(
                            color: MyColors.primaryShade900,
                            fontWeight: FontWeight.w700,
                            height: 1.3,
                            letterSpacing: -0.2,
                          ),
                        ),
                        SizedBox(height: MySizes.spaceSm(context) * 0.5),
                        Text(S.of(context).read_later_stats('8', '2')),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: MySizes.spaceMd(context)),
                ),
                SliverList.separated(
                  separatorBuilder: (context, index) =>
                      SizedBox(height: MySizes.spaceSm(context)),
                  itemBuilder: (BuildContext context, int index) {
                    return ProfileReadingListCard();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
