import 'package:flutter/material.dart';
import 'package:mirath/core/helpers/responsive_helper.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/home/presentation/widgets/paper_card_items.dart';
import 'package:mirath/features/home/presentation/widgets/search_text_field.dart';

class SearchResultScreen extends StatelessWidget {
  const SearchResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          ResponsiveHelper.responsiveValue(context, 50),
        ),
        child: AppBar(
          toolbarHeight: ResponsiveHelper.responsiveValue(context, 50),
          leadingWidth: ResponsiveHelper.responsiveValue(context, 50),
          leading: MyBackIcon(),
          titleSpacing: 0,
          title: SearchTextField(),
        ),
      ),

      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Padding(
            padding: MySizes.paddingMd(context),
            child: ListView.separated(
              separatorBuilder: (context, index) =>
                  SizedBox(height: MySizes.spaceXs(context)),
              padding: EdgeInsets.only(
                top: ResponsiveHelper.responsiveValue(context, 16),
                bottom: ResponsiveHelper.responsiveValue(context, 16),
              ),
              itemCount: 5,
              itemBuilder: (context, index) {
                return PaperCardItems();
              },
            ),
          );
        },
      ),
    );
  }
}
