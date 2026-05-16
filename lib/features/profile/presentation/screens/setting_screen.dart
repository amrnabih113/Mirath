import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../common/widgets/my_back_icon.dart';
import '../widgets/setting_tiles.dart';
import '../../../../generated/l10n.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: MyBackIcon(),
        title: Text(S.of(context).settings),
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
                      S.of(context).account,
                      style: context.bodyLarge.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SettingTiles(
                    icon: HugeIcons.strokeRoundedUser03,
                    text: S.of(context).account_preferences,
                    onTap: () {},
                  ),
                  SettingTiles(
                    icon: HugeIcons.strokeRoundedSecurityCheck,
                    text: S.of(context).sign_in_and_security,
                    onTap: () {},
                  ),
                  SettingTiles(
                    icon: HugeIcons.strokeRoundedNotification01,
                    text: S.of(context).notifications,
                    onTap: () {},
                  ),
                  SettingTiles(
                    icon: HugeIcons.strokeRoundedSquareLock02,
                    text: S.of(context).data_privacy,
                    onTap: () {},
                  ),
                  Padding(
                    padding: EdgeInsetsGeometry.only(
                      left: MySizes.spaceMd(context),
                    ),
                    child: Text(
                      S.of(context).support_and_about,
                      style: context.bodyLarge.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SettingTiles(
                    icon: HugeIcons.strokeRoundedHelpCircle,
                    text: S.of(context).help_and_support,
                    onTap: () {},
                  ),
                  SettingTiles(
                    icon: HugeIcons.strokeRoundedInformationCircle,
                    text: S.of(context).terms_and_policies,
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
