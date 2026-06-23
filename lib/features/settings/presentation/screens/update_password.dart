import 'package:flutter/material.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({super.key});

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  @override
  void initState() {
    super.initState();
    newPasswordController.addListener(() {
      setState(() {});
    });
    confirmPasswordController.addListener(() {
      setState(() {});
    });
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
            TextField(
              cursorColor: MyColors.primaryColor,
              controller: currentPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'your current password',
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
            TextField(
              cursorColor: MyColors.primaryColor,
              controller: newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'your new password',
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
            TextField(
              cursorColor: MyColors.primaryColor,
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Confirm password',
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
                  newPasswordController.text !=
                          confirmPasswordController.text ||
                      newPasswordController.text.isEmpty
                  ? null
                  : () {
                      // Handle password update logic here
                    },
              style: TextButton.styleFrom(
                backgroundColor:
                    newPasswordController.text ==
                            confirmPasswordController.text &&
                        newPasswordController.text.isNotEmpty
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
