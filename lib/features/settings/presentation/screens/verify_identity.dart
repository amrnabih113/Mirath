import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mirath/core/constants/route_names.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/core/utils/my_validators.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:mirath/generated/l10n.dart';

class VerifyIdentity extends StatefulWidget {
  const VerifyIdentity({super.key, required this.nextRoute});

  final String nextRoute;

  @override
  State<VerifyIdentity> createState() => _DeleDeactivAccountState();
}

class _DeleDeactivAccountState extends State<VerifyIdentity> {
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isValid = false;
  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    final valid = _formKey.currentState?.validate() ?? false;

    if (valid != isValid) {
      setState(() {
        isValid = valid;
      });
    } else {
      // عشان الـ TextButton التاني (Update Password) يعمل rebuild
      // كل مرة النص يتغير حتى لو الـ form validity متغيرتش
      setState(() {});
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordController.removeListener(_validateForm);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: MyBackIcon()),
      body: BlocConsumer<SettingsCubit, SettingsState>(
        listener: (context, state) {
          if (state is SettingsSuccess<String>) {
            context.pop();
          } else if (state is SettingsFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errormessage)));
          }
        },
        builder: (context, state) {
          final isLoading = state is SettingsLoading;
          return Padding(
            padding: MySizes.paddingLg(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Enter your password',
                  style: context.bodyLarge.copyWith(fontSize: 24),
                ),
                SizedBox(height: MySizes.spaceXl(context)),
                TextFormField(
                  key: _formKey,
                  cursorColor: MyColors.primaryColor,
                  validator: (value) =>
                      MyValidator.validatePassword(context, value),
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'password',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: MyColors.primaryShade800),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: MyColors.primaryShade800),
                    ),
                  ),
                ),

                SizedBox(height: MySizes.spaceMd(context)),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      context.push(RouteNames.forgetPassword);
                    },
                    child: Text(
                      S.of(context).forgot_password,
                      style: context.bodyMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MySizes.spaceMd(context)),
                TextButton(
                  onPressed: (!isValid || isLoading)
                      ? () {
                          if (widget.nextRoute == RouteNames.deactiveAccount) {
                            context.push(
                              widget.nextRoute,
                              extra: _passwordController.text.trim(),
                            );
                          } else if (widget.nextRoute ==
                              RouteNames.deleteAccount) {
                            context.push(
                              widget.nextRoute,
                              extra: _passwordController.text.trim(),
                            );
                          }
                          context.push(
                            widget.nextRoute,
                            extra: _passwordController.text.trim(),
                          );
                        }
                      : null,
                  style: TextButton.styleFrom(
                    backgroundColor: _passwordController.text.isNotEmpty
                        ? MyColors.primaryShade800
                        : MyColors.primaryShade800.withAlpha(
                            (255 * 0.5).toInt(),
                          ),
                  ),
                  child: Text(
                    'Verify your identity',
                    style: context.bodyLarge.copyWith(color: MyColors.white),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
