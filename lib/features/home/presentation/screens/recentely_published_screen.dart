import 'package:flutter/material.dart';
import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../common/widgets/my_back_icon.dart';
import '../widgets/category_items_list.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/paper_card.dart';

class RecentelyPublishedScreen extends StatelessWidget {
  const RecentelyPublishedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          ResponsiveHelper.responsiveValue(context, 60),
        ),
        child: Center(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 850),
                child: AppBar(
                  leading: MyBackIcon(),
                  title: Text(
                    'Recently Published',
                    style: context.titleLarge.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  centerTitle: true,
                ),
              );
            },
          ),
        ),
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 850),
              child: Padding(
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
                            SizedBox(height: MySizes.spaceMd(context)),
                        padding: EdgeInsets.only(
                          top: ResponsiveHelper.responsiveValue(context, 16),
                          bottom: ResponsiveHelper.responsiveValue(context, 16),
                        ),
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return PaperCard();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
