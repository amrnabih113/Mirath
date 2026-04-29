import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/library/presentation/widgets/read_later_container.dart';
import 'package:mirath/features/library/presentation/widgets/show_create_list_dialog.dart';
import 'package:mirath/features/profile/presentation/widgets/profile_reading_list_card.dart';

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
                        child: TabBarView(
                          children: [
                            SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ReadLaterContainer(),
                                  SizedBox(height: MySizes.spaceSm(context)),

                                  // بدل ListView
                                  ...List.generate(
                                    10,
                                    (index) => Padding(
                                      padding: EdgeInsets.only(
                                        bottom: MySizes.spaceXs(context),
                                      ),
                                      child: ProfileReadingListCard(
                                        onTap: () {
                                          context.push(
                                            '/other-user-reading-list',
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            ListView.separated(
                              padding: const EdgeInsets.all(8),

                              itemCount: 10,
                              itemBuilder: (context, index) =>
                                  ProfileReadingListCard(),
                              //itemBuilder: (context, index) => PaperCard(),
                              separatorBuilder: (context, index) => SizedBox(
                                height: MySizes.spaceXs(context) * 0.5,
                              ),
                            ),
                          ],
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
