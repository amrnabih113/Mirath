import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mirath/core/constants/route_names.dart';
import 'package:mirath/core/ui/widgets/my_app_bar.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/settings/presentation/widgets/bullet_text.dart';

class DeactiveAccount extends StatelessWidget {
  const DeactiveAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        leading: const MyBackIcon(),
        title: Text(
          'Deactivate account',
          style: context.labelLarge.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: MySizes.paddingMd(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What to expect when you deactivate:',
              style: context.bodyLarge.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            BulletText(text: 'You will be logged out'),
            BulletText(
              text:
                  'Your public profile, discussions, and shared reading lists will be hidden from other researchers immediately.',
            ),
            BulletText(
              text:
                  'Your internal data (private lists, annotations, history) is safely preserved.',
            ),
            BulletText(
              text:
                  'You can cancel this deactivation and restore everything instantly just by logging back into Mirath at any time.',
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  context.push(RouteNames.accountManagement);
                },
                style: TextButton.styleFrom(
                  side: const BorderSide(color: MyColors.primaryShade800),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(
                  'Deactivate account',
                  style: const TextStyle(color: MyColors.error),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
