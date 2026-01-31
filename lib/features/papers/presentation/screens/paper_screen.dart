import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/helpers/responsive_helper.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/common/widgets/tag_chip.dart';
import 'package:mirath/features/papers/presentation/widgets/abstract_section.dart';
import 'package:mirath/features/papers/presentation/widgets/expainsion_tile_widget.dart';
import 'package:mirath/features/papers/presentation/widgets/my_text_icon.dart';
import 'package:mirath/features/papers/presentation/widgets/paper_info.dart';

class PaperScreen extends StatelessWidget {
  const PaperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          ResponsiveHelper.responsiveValue(context, 30),
        ),
        child: Center(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 850),
                child: AppBar(
                  leading: MyBackIcon(),
                  actions: [
                    IconButton(
                      icon: HugeIcon(
                        icon: HugeIcons.strokeRoundedMoreHorizontalCircle01,
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
      body: Padding(
        padding: MySizes.paddingMd(context),
        child: SingleChildScrollView(
          child: Column(
            children: [
              PaperInfo(),
              SizedBox(height: MySizes.spaceMd(context)),
              AbstractSection(),
              SizedBox(height: MySizes.spaceMd(context)),
              ExpainsionTileWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
