// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:mirath/core/helpers/responsive_helper.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/common/widgets/section_title.dart';
import 'package:mirath/features/home/presentation/widgets/category_items.dart';
import 'package:mirath/features/home/presentation/widgets/home_search_bar.dart';
import 'package:mirath/features/home/presentation/widgets/paper_card_items.dart';
import 'package:mirath/features/home/presentation/widgets/welcome_header.dart';

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
                  SectionTitle(title: 'Recently Published'),
                  SizedBox(height: MySizes.spaceSm(context)),
                  SizedBox(
                    height: ResponsiveHelper.responsiveValue(context, 40),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return CategoryItems();
                      },
                    ),
                  ),
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
