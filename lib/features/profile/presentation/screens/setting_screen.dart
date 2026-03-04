import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/profile/presentation/widgets/setting_tiles.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: MyBackIcon(),
        title: Text('Settings'),
        centerTitle: true,
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 850),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsetsGeometry.only(
                      left: MySizes.spaceMd(context),
                    ),
                    child: Text(
                      'Account',
                      style: context.bodyLarge.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SettingTiles(
                    icon: HugeIcons.strokeRoundedUser03,
                    text: 'Account preferences',
                    onTap: () {},
                  ),
                  SettingTiles(
                    icon: HugeIcons.strokeRoundedSecurityCheck,
                    text: 'Sign in & security',
                    onTap: () {},
                  ),
                  SettingTiles(
                    icon: HugeIcons.strokeRoundedNotification01,
                    text: 'Notifications',
                    onTap: () {},
                  ),
                  SettingTiles(
                    icon: HugeIcons.strokeRoundedSquareLock02,
                    text: 'Data privacy',
                    onTap: () {},
                  ),
                  Padding(
                    padding: EdgeInsetsGeometry.only(
                      left: MySizes.spaceMd(context),
                    ),
                    child: Text(
                      'Support & about',
                      style: context.bodyLarge.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SettingTiles(
                    icon: HugeIcons.strokeRoundedHelpCircle,
                    text: 'Help & support',
                    onTap: () {},
                  ),
                  SettingTiles(
                    icon: HugeIcons.strokeRoundedInformationCircle,
                    text: 'Terms & policies',
                    onTap: () {},
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
