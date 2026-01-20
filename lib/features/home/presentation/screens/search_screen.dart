import 'package:flutter/material.dart';
import 'package:mirath/core/helpers/responsive_helper.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/home/presentation/widgets/search_item.dart';
import 'package:mirath/features/home/presentation/widgets/search_screen_heading.dart';
import 'package:mirath/features/home/presentation/widgets/search_text_field.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            title: SearchTextField(),
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
                SearchScreenHeading(),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) =>
                        SizedBox(height: MySizes.spaceXs(context)),
                    padding: EdgeInsets.zero,
                    itemCount: 30,
                    itemBuilder: (context, index) {
                      return SearchItem();
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
