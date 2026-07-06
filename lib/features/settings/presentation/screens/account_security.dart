import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/constants/route_names.dart';
import 'package:mirath/core/ui/widgets/my_app_bar.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:mirath/features/settings/presentation/widgets/account_tiles.dart';
import 'package:mirath/features/settings/presentation/widgets/dialogs.dart';
import 'package:mirath/features/settings/presentation/widgets/special_text.dart';

class AccountSecurity extends StatelessWidget {
  const AccountSecurity({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        leading: MyBackIcon(),
        title: Text(
          'Account & Security',
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
                'Account Settings',
                style: context.bodyLarge.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              AccountTiles(
                icon: HugeIcons.strokeRoundedStudentCard,
                title: 'Username',
                subtitle: 'johndoe',
                btnName: 'change',
                onTap: () {
                  context.push(RouteNames.changeUsername);
                },
              ),
              Divider(color: MyColors.grey, thickness: 2),
              AccountTiles(
                icon: HugeIcons.strokeRoundedMail01,
                title: 'Email address',
                subtitle: 'johndoe@gmail.com',
                onTap: () {
                  context.push(RouteNames.changeEmail);
                  
                },
                btnName: 'change',
              ),
              Divider(color: MyColors.grey, thickness: 2),
              AccountTiles(
                icon: HugeIcons.strokeRoundedSquareLock01,
                title: 'Password',
                subtitle: '',
                onTap: () {
                  context.push(RouteNames.updatePassword);
                },
                btnName: 'update',
              ),
              Divider(color: MyColors.grey, thickness: 2),
              Text(
                'Linked accounts',
                style: context.bodyLarge.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              BlocConsumer<SettingsCubit, SettingsState>(
                listener: (context, state) {
                  if (state is SettingsSuccess<String>) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.data)));
                  }
                },
                builder: (context, state) {
                  bool isClicked = state is SettingsSuccess<String>;
                  return AccountTiles(
                    icon: HugeIcons.strokeRoundedGoogle,
                    title: 'Google',
                    subtitle: 'Sign in with your Google account',
                    onTap: () {
                      context.read<SettingsCubit>().disconnectGoogleAccount();
                    },
                    btnName: isClicked ? 'Connect' : 'Disconnect',
                    isClicked: isClicked,
                  );
                },
              ),
              Divider(color: MyColors.grey, thickness: 2),

              AccountTiles(
                icon: HugeIcons.strokeRoundedApple,
                title: 'Apple',
                subtitle: 'Sign in with your Apple account',
                onTap: () {},
                btnName: 'Connect',
                isClicked: true,
              ),

              Divider(color: MyColors.grey, thickness: 2),
              Text(
                'Security & Login',
                style: context.bodyLarge.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              AccountTiles(
                title: 'Two-factor authentication',
                subtitleWidget: SpecialText(
                  text: 'Add a second verification step',
                  addText: 'Recommended',
                  style: context.bodyLarge.copyWith(
                    fontSize: 14,
                    color: const Color(0xff333333),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                onTap: () {},
                btnName: 'Enable',
                isClicked: true,
              ),
              Divider(color: MyColors.grey, thickness: 2),
              Text(
                'Active sessions',
                style: context.bodyLarge.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              AccountTiles(
                titleWidget: SpecialText(
                  text: 'iPhone 13',
                  addText: 'Current',
                  backColor: MyColors.success.withAlpha((255 * .7).toInt()),
                  style: context.bodyLarge.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitleWidget: DeviceLocation(title: 'Cairo, EG • 3 days ago'),

                onTap: () {},
              ),
              Divider(color: MyColors.grey, thickness: 2),
              AccountTiles(
                title: 'iPad mini',
                subtitleWidget: DeviceLocation(
                  title: 'Cairo, EG • 3 months ago',
                ),
                onTap: () {
                  showLogoutDialog(
                    context,
                    title: 'Log out of device?',
                    content:
                        'Are you sure you want to log out of your iPad mini session in Cairo, EG?',
                    fTextBtn: 'Log out',
                    sTextBtn: 'Cancel',
                    ontap: () {
                      context
                          .read<SettingsCubit>()
                          .revokeAllActiveSessionsExceptCurrent();
                    },
                  );
                },
                btnName: 'Log out',
                textColor: MyColors.error,
              ),
              Divider(color: MyColors.grey, thickness: 2),
              AccountTiles(
                title: 'Log out of all other sessions',
                subtitle: 'Log out of all session except current one',
                onTap: () {
                  showLogoutDialog(
                    context,
                    title: 'Log out all other sessions?',
                    content:
                        'You will remain logged in on this device, but will be securely signed out everywhere else.',
                    fTextBtn: 'Log out all',
                    sTextBtn: 'Cancel',
                    ontap: () {
                      context
                          .read<SettingsCubit>()
                          .revokeAllActiveSessionsExceptCurrent();
                    },
                  );
                },
                btnName: 'Log out all',
                textColor: MyColors.error,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DeviceLocation extends StatelessWidget {
  const DeviceLocation({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        HugeIcon(
          icon: HugeIcons.strokeRoundedLocation01,
          size: MySizes.iconSmall(context) * .8,
        ),
        SizedBox(width: 4),
        Text(
          title,
          style: context.bodyLarge.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xff333333),
          ),
        ),
      ],
    );
  }
}
