import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mirath/core/constants/route_names.dart';
import 'package:mirath/core/ui/widgets/my_app_bar.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/auth/presentation/widgets/otp_widget.dart';
import 'package:mirath/features/auth/presentation/widgets/timer_widget.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/common/widgets/screen_decoration.dart';
import 'package:mirath/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:mirath/generated/l10n.dart';

class ConfirmEmail extends StatelessWidget {
  ConfirmEmail({super.key, required this.newEmail});

  final String newEmail;
  final ValueNotifier<String> _otpCodeNotifier = ValueNotifier<String>("");

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return BlocListener<SettingsCubit, SettingsState>(
      listener: (context, state) {
        if (state is SettingsSuccess) {
          // نجاح التأكيد - ممكن ترجع للصفحة السابقة أو تعمل navigation
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.data.toString())));
          context.push(RouteNames.accountSecurity);
        } else if (state is SettingsFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errormessage)));
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: MyAppBar(
          leading: MyBackIcon(),
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: true,
        ),
        body: ScreenDecoration(
          dark: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final topGap = screenHeight * 0.05;
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: topGap,
                    left: MySizes.spaceLg(context),
                    right: MySizes.spaceLg(context),
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 850),
                      child: Column(
                        children: [
                          SizedBox(height: screenHeight * 0.15),
                          BlocBuilder<SettingsCubit, SettingsState>(
                            builder: (context, state) {
                              final isLoading = state is SettingsLoading;
                              return Column(
                                children: [
                                  OtpWidget(
                                    title: 'Confirm Email',
                                    description: S
                                        .of(context)
                                        .OTP_code_description,
                                    onOtpCompleted: (value) {
                                      _otpCodeNotifier.value = value;
                                    },
                                  ),
                                  ValueListenableBuilder(
                                    valueListenable: _otpCodeNotifier,
                                    builder: (context, otpCode, _) {
                                      return SizedBox(
                                        width: MySizes.buttonWidth(context),
                                        child: ElevatedButton(
                                          onPressed: otpCode.length == 6
                                              ? () {
                                                  context
                                                      .read<SettingsCubit>()
                                                      .confirmEmail(
                                                        newEmail: newEmail,
                                                        otpCode: otpCode,
                                                      );
                                                }
                                              : null,
                                          child: isLoading
                                              ? SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                          Color
                                                        >(
                                                          MyColors
                                                              .primaryShade50,
                                                        ),
                                                  ),
                                                )
                                              : Text(
                                                  S.of(context).Verify_email,
                                                ),
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(height: MySizes.spaceMd(context)),
                                  TimerWidget(),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
