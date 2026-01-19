import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/helpers/responsive_helper.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/home/presentation/widgets/search_item.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _Searchcontroller = TextEditingController();
    return Scaffold(
      backgroundColor: MyColors.light,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          ResponsiveHelper.responsiveValue(context, 50),
        ),
        child: SafeArea(
          bottom: false,
          child: AppBar(
            leadingWidth: ResponsiveHelper.responsiveValue(context, 50),
            leading: MyBackIcon(),
            titleSpacing: 0,
            title: Padding(
              padding: EdgeInsets.only(right: MySizes.spaceMd(context)),
              child: TextField(
                controller: _Searchcontroller,
                cursorColor: MyColors.primaryShade500,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: MySizes.spaceSm(context),
                    horizontal: MySizes.spaceMd(context),
                  ),
                  filled: true,
                  fillColor: MyColors.white,
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(
                      left: MySizes.spaceSm(context),
                      right: MySizes.spaceXs(context),
                    ),
                    child: HugeIcon(icon: HugeIcons.strokeRoundedSearch01),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: HugeIcon(icon: HugeIcons.strokeRoundedCamera01),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      MySizes.borderRadiusSm(context),
                    ),
                    borderSide: BorderSide(
                      color: MyColors.primaryShade800,
                      width: 1.2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      MySizes.borderRadiusSm(context),
                    ),
                    borderSide: BorderSide(
                      color: MyColors.primaryShade800,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),

      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.responsiveValue(context, 14),
              vertical: ResponsiveHelper.responsiveValue(context, 0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent searches',
                      style: context.labelLarge.copyWith(
                        color: MyColors.darkerGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Clear All',
                        style: context.titleSmall.copyWith(
                          color: MyColors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                ListView.separated(
                  separatorBuilder: (context, index) =>
                      SizedBox(height: MySizes.spaceXs(context)),
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return SearchItem();
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
