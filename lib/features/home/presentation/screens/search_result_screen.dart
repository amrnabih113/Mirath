import 'package:flutter/material.dart';
import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../common/widgets/my_back_icon.dart';
import '../widgets/search_text_field.dart';

class HomeSearchResultScreen extends StatelessWidget {
  const HomeSearchResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          ResponsiveHelper.responsiveValue(context, 55),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Center(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 850),
                  child: AppBar(
                    toolbarHeight: ResponsiveHelper.responsiveValue(
                      context,
                      50,
                    ),
                    leadingWidth: ResponsiveHelper.responsiveValue(context, 50),
                    leading: MyBackIcon(),
                    titleSpacing: 0,
                    title: SearchTextField(),
                  ),
                );
              },
            ),
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
                child: ListView.separated(
                  separatorBuilder: (context, index) =>
                      SizedBox(height: MySizes.spaceXs(context)),
                  padding: EdgeInsets.only(
                    top: ResponsiveHelper.responsiveValue(context, 16),
                    bottom: ResponsiveHelper.responsiveValue(context, 16),
                  ),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return SizedBox();
                    //PaperCard();
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
