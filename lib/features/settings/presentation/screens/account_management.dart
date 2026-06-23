import 'package:flutter/material.dart';
import 'package:mirath/core/ui/widgets/my_app_bar.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';

class AccountManagement extends StatelessWidget {
  const AccountManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        leading: MyBackIcon(),
        title: Text(
          'Account Management',
          style: context.labelLarge.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
    );
  }
}
