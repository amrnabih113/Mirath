import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.success) {
          MyLoaders.successSnackBar(
            context: context,
            title: 'Success',
            message: 'Profile set up successfully!',
          );
          context.go('/home');
        } else if (state.status == AuthStatus.error) {
          // Show error message
          MyLoaders.errorSnackBar(
            context: context,
            title: 'Error',
            message: state.message ?? 'Profile setup failed',
          );
        }
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final isLoading = state.status == AuthStatus.loading;
          return SizedBox(
            width: MySizes.buttonWidth(context),
            child: ElevatedButton(
              onPressed: selectedInterests.isEmpty || isLoading
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
                  : Text(
                      'Next',
                      style: context.titleMedium.copyWith(
                        color: MyColors.light,
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
