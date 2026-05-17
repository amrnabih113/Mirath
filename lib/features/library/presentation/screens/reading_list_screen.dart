import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../common/widgets/my_back_icon.dart';
import '../widgets/show_create_list_dialog.dart';
import 'tabs/saved_papers_tab.dart';
import 'tabs/your_lists_tab.dart';
import '../../../../core/ui/widgets/my_app_bar.dart';
import '../../../../core/ui/widgets/my_body.dart';

class ReadingListScreen extends StatelessWidget {
  const ReadingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: MyAppBar(
          leading: MyBackIcon(),
          actions: [
            IconButton(
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedPlusSign,
                size: MySizes.iconMedium(context),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const CreateListDialog(),
                );
              },
            ),
          ],
        ),
        body: MyBody(
          child: Column(
            children: [
              TabBar(
                indicatorColor: MyColors.primaryShade900,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                tabs: const [
                  Tab(text: 'Your Lists'),
                  Tab(text: 'Saved lists'),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: MySizes.paddingSm(context),
                  child: const TabBarView(
                    children: [YourListsTab(), SavedPapersTab()],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
