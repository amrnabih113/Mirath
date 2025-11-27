
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirath/core/helpers/my_helper_functions.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_images.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/auth/presentation/cubit/auth_cubit.dart';

class SocialButtons extends StatelessWidget {
  const SocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = MyHelperFunctions.isDarkMode(context);
    return Column(
      children: [
        Text("Or sign in with", style: context.bodyMedium),
        SizedBox(height: MySizes.spaceLg(context)),
        BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            final isLoading = state.status == AuthStatus.loading;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: isLoading
                      ? null
                      : () {
                          context.read<AuthCubit>().signInWithGoogle();
                        },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: MyColors.primaryShade400,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Opacity(
                      opacity: isLoading ? 0.3 : 1.0,
                      child: Image.asset(
                        MyImages.googleLogo,
                        color: isDark ? MyColors.light : null,
                        width: 32,
                        height: 32,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: MySizes.spaceLg(context)),
                InkWell(
                  onTap: isLoading
                      ? null
                      : () {
                          context.read<AuthCubit>().signInWithApple();
                        },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: MyColors.primaryShade400,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Opacity(
                      opacity: isLoading ? 0.3 : 1.0,
                      child: Image.asset(
                        color: isDark ? MyColors.light : null,

                        MyImages.appleLogo,
                        width: 32,
                        height: 32,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

