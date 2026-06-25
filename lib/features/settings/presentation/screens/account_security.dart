import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/constants/route_names.dart';
import 'package:mirath/core/ui/widgets/my_app_bar.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/settings/presentation/widgets/account_tiles.dart';

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
              AccountTiles(
                icon: HugeIcons.strokeRoundedGoogle,
                title: 'Google',
                subtitle: 'Sign in with your Google account',
                onTap: () {},
                btnName: 'Disconnect',
                isClicked: true,
              ),
              Divider(color: MyColors.grey, thickness: 2),
              AccountTiles(
                icon: HugeIcons.strokeRoundedApple,
                title: 'Apple',
                subtitle: 'Sign in with your Apple account',
                onTap: () {},
                btnName: 'connect',
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
                subtitleWidget: const SpecialText(
                  text: 'Add a second verification step',
                  addText: 'Recommended',
                ),
                onTap: () {},
                btnName: 'Enable',
                isClicked: true,
              ),
              Divider(color: MyColors.grey, thickness: 2),
              Text(
                'Active sessions',
                style: context.bodyLarge.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              AccountTiles(
                titleWidget: SpecialText(
                  text: 'iPhone 13',
                  addText: 'Current',
                  backColor: MyColors.success.withAlpha((255 * .7).toInt()),
                ),
                subtitle: 'Cairo, EG • 3 days ago', onTap: () {  },
              ),
              Divider(color: MyColors.grey, thickness: 2),
              AccountTiles(
                title: 'iPad mini',
                subtitle: 'Cairo, EG • 3 months ago',
                onTap: () {
                  _showLogoutDialog(
                    context,
                    title: 'Log out of device?',
                    content:
                        'Are you sure you want to log out of your iPad mini session in Cairo, EG?',
                    fTextBtn: 'Log out',
                    sTextBtn: 'Cancel',
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
                  _showLogoutDialog(
                    context,
                    title: 'Log out all other sessions?',
                    content:
                        'You will remain logged in on this device, but will be securely signed out everywhere else.',
                    fTextBtn: 'Log out all',
                    sTextBtn: 'Cancel',
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

  void _showLogoutDialog(
    BuildContext context, {
    required String title,
    required String content,
    required String fTextBtn,
    required String sTextBtn,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) => Center(
        child: AlertDialog(
          actionsPadding: EdgeInsets.zero,
          title: Text(title, textAlign: TextAlign.center),
          content: Text(content, textAlign: TextAlign.center),
          actions: [
            const Divider(color: MyColors.grey, thickness: 1),
            Center(
              child: TextButton(
                onPressed: () {},
                child: Text(
                  fTextBtn,
                  style: context.bodyLarge.copyWith(color: MyColors.error),
                ),
              ),
            ),
            const Divider(color: MyColors.grey, thickness: 1),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(sTextBtn),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SpecialText extends StatelessWidget {
  const SpecialText({
    super.key,
    required this.text,
    required this.addText,
    this.backColor,
  });
  final String text;
  final String addText;
  final Color? backColor;
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodySmall,
        children: [
          TextSpan(text: text, style: context.bodyLarge.copyWith(fontSize: 14)),

          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Container(
              padding: MySizes.paddingSm(context) * .5,
              margin: const EdgeInsets.only(left: 4),
              decoration: BoxDecoration(
                color: backColor ?? MyColors.primaryShade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                addText,
                style: TextStyle(
                  color: MyColors.primaryShade900,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
