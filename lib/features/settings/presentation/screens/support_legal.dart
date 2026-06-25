import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/ui/widgets/my_app_bar.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/settings/presentation/screens/account_security.dart';
import 'package:mirath/features/settings/presentation/widgets/account_tiles.dart';

class SupportLegal extends StatelessWidget {
  const SupportLegal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        leading: MyBackIcon(),
        title: Text(
          'Support & Legal',
          style: context.labelLarge.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: MySizes.paddingMd(context),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Help & Support',
                style: context.bodyLarge.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              AccountTiles(
                title: 'Help center',
                btnName: 'Open',
                buttonIcon: HugeIcons.strokeRoundedLinkSquare01,
                onTap: () {},
              ),
              Divider(color: MyColors.darkGrey, thickness: 1),
              AccountTiles(
                title: 'Contact support',
                btnName: 'Contact',
                onTap: () {},
              ),
              Divider(color: MyColors.darkGrey, thickness: 1),
              AccountTiles(
                title: 'Report a bug',
                btnName: 'Report',
                onTap: () {},
              ),
              Divider(color: MyColors.darkGrey, thickness: 1),
              Text(
                'Legal & About',
                style: context.bodyLarge.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              AccountTiles(
                title: 'Terms and conditions',
                btnName: 'Read',
                buttonIcon: HugeIcons.strokeRoundedArrowRight01,
                onTap: () {},
              ),
              Divider(color: MyColors.darkGrey, thickness: 1),
              AccountTiles(
                title: 'Privacy policy',
                btnName: 'Read',
                buttonIcon: HugeIcons.strokeRoundedArrowRight01,
                onTap: () {},
              ),
              Divider(color: MyColors.darkGrey, thickness: 1),
              AccountTiles(
                title: 'Cookie policy',
                btnName: 'Read',
                buttonIcon: HugeIcons.strokeRoundedArrowRight01,
                onTap: () {},
              ),
              Divider(color: MyColors.darkGrey, thickness: 1),
              AccountTiles(
                title: 'Open source licenses',
                btnName: 'Read',
                buttonIcon: HugeIcons.strokeRoundedArrowRight01,
                onTap: () {},
              ),
              Divider(color: MyColors.darkGrey, thickness: 1),
              Text(
                'App Info',
                style: context.bodyLarge.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              AccountTiles(title: 'App version', subtitle: 'v1.0.0 • API v1'),
            ],
          ),
        ),
      ),
    );
  }
}
