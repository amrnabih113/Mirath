import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../common/widgets/section_title.dart';
import '../widgets/category_items_list.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/paper_card_items.dart';
import '../widgets/welcome_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          ResponsiveHelper.responsiveValue(context, 70),
        ),
        child: WelcomeHeader(),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 850),
              child: ListView(
                padding: MySizes.paddingMd(context),
                children: [
                  HomeSearchBar(),
                  SizedBox(height: MySizes.spaceMd(context)),
                  SectionTitle(
                    title: 'Recently Published',
                    onTap: () => context.push("/recentely-published"),
                  ),
                  SizedBox(height: MySizes.spaceSm(context)),
                  CategoryItemsList(),
                  SizedBox(height: MySizes.spaceLg(context)),
                  SectionTitle(title: 'You might also like', showSeeAll: false),
                  SizedBox(height: MySizes.spaceSm(context)),
                  ListView.separated(
                    separatorBuilder: (context, index) =>
                        SizedBox(height: MySizes.spaceXs(context)),
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return PaperCardItems();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
