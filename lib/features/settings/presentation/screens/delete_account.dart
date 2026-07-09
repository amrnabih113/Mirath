import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirath/core/ui/widgets/my_app_bar.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:mirath/features/settings/presentation/screens/account_management.dart';
import 'package:mirath/features/settings/presentation/widgets/bullet_text.dart';

class DeleteAccount extends StatelessWidget {
  const DeleteAccount({super.key, required this.pass});
  final String pass;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsCubit, SettingsState>(
      listener: (context, state) {
        if (state is SettingsSuccess<String>) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.data)));

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const AccountManagement()),
            (route) => false,
          );
        }

        if (state is SettingsFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errormessage)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: MyAppBar(
            leading: const MyBackIcon(),
            title: Text(
              'Delete account',
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
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black,
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(
                        text: 'Warning: ',
                        style: context.bodyLarge.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: MyColors.error,
                        ),
                      ),
                      TextSpan(
                        text:
                            'This action cannot be undone. Once you confirm, your profile will be scheduled for permanent deletion.',
                        style: context.bodyLarge.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                BulletText(
                  text:
                      'What will be lost: All your personal reading lists, private notes, annotations, search history, and profile data will be permanently wiped from our servers.',
                ),
                BulletText(
                  text:
                      'Discussions: Any public comments or academic discussions you started will be anonymized.',
                ),
                BulletText(
                  text:
                      '30-Day Grace Period: You have 30 days to change your mind.',
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      context.read<SettingsCubit>().deleteAccount(
                        password: pass,
                      );
                    },
                    style: TextButton.styleFrom(
                      side: const BorderSide(color: MyColors.primaryShade800),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Text(
                      'Permanently delete account',
                      style: const TextStyle(color: MyColors.error),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
