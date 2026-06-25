import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mirath/core/constants/route_names.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';

class VerifyIdentity extends StatefulWidget {
  const VerifyIdentity({super.key, required this.nextRoute});

  final String nextRoute;

  @override
  State<VerifyIdentity> createState() => _DeleDeactivAccountState();
}

class _DeleDeactivAccountState extends State<VerifyIdentity> {
  TextEditingController passwordController = TextEditingController();
  @override
  void initState() {
    super.initState();
    passwordController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    passwordController.dispose();
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
              'Enter your password',
              style: context.bodyLarge.copyWith(fontSize: 24),
            ),
            SizedBox(height: MySizes.spaceXl(context)),
            TextField(
              cursorColor: MyColors.primaryColor,
              controller: passwordController,
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
              onPressed: passwordController.text.isNotEmpty
                  ? () {
                      if (widget.nextRoute == RouteNames.deactiveAccount) {
                        context.push(widget.nextRoute);
                      } else if (widget.nextRoute == RouteNames.deleteAccount) {
                        context.push(widget.nextRoute);
                      }
                      context.push(widget.nextRoute);
                    }
                  : null,
              style: TextButton.styleFrom(
                backgroundColor: passwordController.text.isNotEmpty
                    ? MyColors.primaryShade800
                    : MyColors.primaryShade800.withAlpha((255 * 0.5).toInt()),
              ),
              child: Text(
                'Verify your identity',
                style: context.bodyLarge.copyWith(color: MyColors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
