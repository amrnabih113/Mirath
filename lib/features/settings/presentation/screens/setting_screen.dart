import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/constants/route_names.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mirath/features/settings/presentation/widgets/dialogs.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../common/widgets/my_back_icon.dart';
import '../widgets/setting_tiles.dart';
import '../../../../generated/l10n.dart';
import '../../../../core/ui/widgets/my_app_bar.dart';
import '../../../../core/ui/widgets/my_body.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        leading: MyBackIcon(),
        title: Text(
          S.of(context).settings,
          style: context.labelLarge.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: MyBody(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Padding(
              //   padding: EdgeInsetsGeometry.only(left: MySizes.spaceMd(context)),
              //   child: Text(
              //     S.of(context).account,
              //     style: context.bodyLarge.copyWith(
              //       fontSize: 16,
              //       fontWeight: FontWeight.w500,
              //     ),
              //   ),
              // ),
              SettingTiles(
                icon: HugeIcons.strokeRoundedUser03,
                title: 'Account & Security',
                subtitle: 'Email, password, 2FA, and active sessions',
                onTap: () {
                  context.push(RouteNames.accountSecurity);
                },
              ),
              SettingTiles(
                icon: HugeIcons.strokeRoundedNews01,
                title: 'Feed & AI Preferences',
                subtitle: 'Tailor your recommendation engine and history',
                onTap: () {
                  context.push(RouteNames.feedAiPreferences);
                },
              ),
              SettingTiles(
                icon: HugeIcons.strokeRoundedPaintBoard,
                title: 'Reading & Appearance',
                subtitle: 'Dark mode, font sizes, and annotation colors',
                onTap: () {
                  context.push(RouteNames.readingAppearance);
                },
              ),
              SettingTiles(
                icon: HugeIcons.strokeRoundedNotification01,
                title: S.of(context).notifications,
                subtitle: 'Manage your social and research alerts',
                onTap: () {
                  context.push(RouteNames.notifications);
                },
              ),
              SettingTiles(
                icon: HugeIcons.strokeRoundedSecurity,
                title: 'Privacy & Data Control',
                subtitle: 'Profile visibility, block lists, and data exports',
                onTap: () {
                  context.push(RouteNames.privacyDataControl);
                },
              ),
              // Padding(
              //   padding: EdgeInsetsGeometry.only(left: MySizes.spaceMd(context)),
              //   child: Text(
              //     S.of(context).support_and_about,
              //     style: context.bodyLarge.copyWith(
              //       fontSize: 16,
              //       fontWeight: FontWeight.w500,
              //     ),
              //   ),
              // ),
              SettingTiles(
                icon: HugeIcons.strokeRoundedHelpCircle,
                title: 'Support & Legal',
                subtitle: 'Help center, bug reporting, and policies',
                onTap: () {
                  context.push(RouteNames.supportLegal);
                },
              ),
              SettingTiles(
                icon: HugeIcons.strokeRoundedInformationCircle,
                title: 'Account Management',
                subtitle: 'Deactivate or permanently delete your account.',
                onTap: () {
                  context.push(RouteNames.accountManagement);
                },
              ),
              Divider(color: MyColors.grey, thickness: 2),
              TextButton.icon(
                onPressed: () {
                  showLogoutDialog(
                    context,
                    title: S.of(context).sign_out,
                    content: S.of(context).are_you_sure_you_want_to_sign_out,
                    fTextBtn: S.of(context).sign_out,
                    sTextBtn: S.of(context).cancel,
                    ontap: () {
                      Navigator.pop(context);
                      context.read<AuthCubit>().signOut();
                    },
                  );
                },
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedLogout02,
                  size: MySizes.iconMedium(context),
                  color: Colors.black,
                ),
                label: Text(
                  'Log out',
                  style: context.bodyLarge.copyWith(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
