import 'package:flutter/material.dart';
import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../common/widgets/my_back_icon.dart';
import '../widgets/category_items_list.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/paper_card_items.dart';

class RecentelyPublishedScreen extends StatelessWidget {
  const RecentelyPublishedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: MyBackIcon(),
        title: Text(
          'Recently Published',
          style: context.titleLarge.copyWith(fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Padding(
            padding: MySizes.paddingMd(context),
            child: Column(
              children: [
                HomeSearchBar(),
                SizedBox(height: MySizes.spaceSm(context)),
                CategoryItemsList(selectedCategory: 'Science'),
                SizedBox(height: MySizes.spaceSm(context)),
                Expanded(
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
