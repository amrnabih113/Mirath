import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/helpers/responsive_helper.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/home/domain/entities/paper_entity.dart';
import 'package:mirath/features/papers/presentation/widgets/abstract_section.dart';
import 'package:mirath/features/papers/presentation/widgets/expainsion_tile_widget.dart';
import 'package:mirath/features/papers/presentation/widgets/paper_info.dart';

class PaperScreen extends StatelessWidget {
  final PaperEntity paper;

  const PaperScreen({super.key, required this.paper});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          ResponsiveHelper.responsiveValue(context, 56),
        ),
        child: Center(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 850),
                child: AppBar(
                  leading: MyBackIcon(),
                  actions: [
                    IconButton(
                      icon: HugeIcon(
                        icon: HugeIcons.strokeRoundedMoreHorizontal,
                        size: MySizes.iconLarge(context),
                        color: Colors.black,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 850),
              child: Padding(
                padding: MySizes.paddingMd(context),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      PaperInfo(paper: paper),
                      SizedBox(height: MySizes.spaceMd(context)),
                      AbstractSection(abstractText: paper.abstract),
                      SizedBox(height: MySizes.spaceMd(context)),
                      ExpainsionTileWidget(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
