import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mirath/core/constants/route_names.dart';
import 'package:mirath/core/ui/widgets/my_app_bar.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/settings/presentation/widgets/manage_tile.dart';

class AccountManagement extends StatelessWidget {
  const AccountManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        leading: MyBackIcon(),
        title: Text(
          'Account Management',
          style: context.labelLarge.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: MySizes.paddingMd(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ManageTile(
              title: 'Deactivate account',
              subtitle:
                  'Deactivating your account is temporary. Your profile will be hidden and you will be logged out. Reactivate anytime by logging back in.',
              btnName: 'Deactivate my account',
              textColor: MyColors.error,
              onTap: () {
                context.push(
                  RouteNames.verifyIdentity,
                  extra: RouteNames.deactiveAccount,
                );
              },
            ),
            Divider(color: MyColors.grey, thickness: 2),
            ManageTile(
              title: 'Delete account',
              subtitle:
                  'Deleting your account is permanent. When you delete your account, your profile, lists, and data will be permanently removed. A 30-day grace period applies before final deletion.',
              btnName: 'Delete my account',
              textColor: MyColors.error,
              onTap: () {
                context.push(
                  RouteNames.verifyIdentity,
                  extra: RouteNames.deleteAccount,
                );
              },
            ),
            Divider(color: MyColors.grey, thickness: 2),
          ],
        ),
      ),
    );
  }
}
