import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/library/presentation/widgets/show_create_list_dialog.dart';
import 'tabs/your_lists_tab.dart';
import 'tabs/saved_papers_tab.dart';

class ReadingListScreen extends StatelessWidget {
  const ReadingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
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
        body: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 850),
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
              );
            },
          ),
        ),
      ),
    );
  }
}
