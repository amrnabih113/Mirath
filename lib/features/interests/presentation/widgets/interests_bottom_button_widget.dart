import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mirath/core/constants/route_names.dart';

import '../../../../core/helpers/my_loaders.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../users/domain/entities/profile_setup_data.dart';

class InterestsBottomButtonWidget extends StatelessWidget {
  final List<String> selectedInterests;
  final ProfileSetupData userProfile;

  const InterestsBottomButtonWidget({
    super.key,
    required this.selectedInterests,
    required this.userProfile,
  });

  @override
  Widget build(BuildContext context) {
    final hasExceededLimit = selectedInterests.length > 10;
    final isValid = selectedInterests.isNotEmpty && !hasExceededLimit;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.error) {
          MyLoaders.errorSnackBar(
            context: context,
            title: "Oh no! ",
            message: state.message ?? 'Something went wrong',
          );
        } else if (state.status == AuthStatus.success) {
          MyLoaders.successSnackBar(
            context: context,
            title: "Success! ",
            message: state.message ?? 'Profile setup completed successfully',
          );
          // Navigate to home after a brief delay to show the success message
          Future.delayed(const Duration(milliseconds: 800), () {
            if (context.mounted) {
              context.go(RouteNames.home);
            }
          });
        }
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final isLoading = state.status == AuthStatus.loading;
          return SizedBox(
            width: MySizes.buttonWidth(context),
            child: ElevatedButton(
              onPressed: !isValid || isLoading
                  ? null
                  : () {
                      context.read<AuthCubit>().setUpProfile(
                        userProfile.copyWith(interests: selectedInterests),
                      );
                    },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: MySizes.spaceMd(context),
                  horizontal: MySizes.spaceLg(context),
                ),
              ),
              child: isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          MyColors.primaryShade50,
                        ),
                      ),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Next',
                          style: context.titleMedium.copyWith(
                            color: MyColors.light,
                          ),
                        ),
                        if (hasExceededLimit)
                          Text(
                            '(Max 10 interests)',
                            style: context.bodySmall.copyWith(
                              color: MyColors.light.withValues(alpha: 0.8),
                            ),
                          ),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }
}
