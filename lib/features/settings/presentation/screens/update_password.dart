import 'package:flutter/material.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/settings/presentation/widgets/setting_text_field.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({super.key});

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  @override
  void initState() {
    super.initState();
    _newPasswordController.addListener(() {
      setState(() {});
    });
    _confirmPasswordController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: MyBackIcon()),
      body: Padding(
        padding: MySizes.paddingLg(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Update Your Password',
              style: context.bodyLarge.copyWith(fontSize: 24),
            ),
            SizedBox(height: MySizes.spaceXl(context)),
            SettingsTextField(
              controller: _currentPasswordController,
              hintText: 'your current password',
            ),
            SizedBox(height: MySizes.spaceMd(context)),
            SettingsTextField(
              controller: _newPasswordController,
              hintText: 'your new password',
            ),
            SizedBox(height: MySizes.spaceMd(context)),
            SettingsTextField(
              controller: _confirmPasswordController,
              hintText: 'Confirm password',
            ),
            SizedBox(height: MySizes.spaceMd(context)),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Forgot Password?',
                  style: context.bodyLarge.copyWith(
                    fontSize: 16,
                    color: MyColors.primaryShade900,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),

            TextButton(
              onPressed:
                  _newPasswordController.text !=
                          _confirmPasswordController.text ||
                      _newPasswordController.text.isEmpty
                  ? null
                  : () {
                      // Handle password update logic here
                    },
              style: TextButton.styleFrom(
                backgroundColor:
                    _newPasswordController.text ==
                            _confirmPasswordController.text &&
                        _newPasswordController.text.isNotEmpty
                    ? MyColors.primaryShade800
                    : MyColors.primaryShade800.withAlpha((255 * 0.5).toInt()),
              ),
              child: Text(
                'Update Password',
                style: context.bodyLarge.copyWith(color: MyColors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
