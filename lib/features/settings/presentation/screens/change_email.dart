import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mirath/core/constants/route_names.dart';
import 'package:mirath/core/utils/my_validators.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:mirath/features/settings/presentation/widgets/change_user_card.dart';

class ChangeEmail extends StatefulWidget {
  const ChangeEmail({super.key});

  @override
  State<ChangeEmail> createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  bool isValid = false;

  @override
  void initState() {
    super.initState();

    _emailController.addListener(() {
      final valid = _formKey.currentState?.validate() ?? false;

      if (valid != isValid) {
        setState(() {
          isValid = valid;
        });
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: MyBackIcon()),
      body: Form(
        key: _formKey,
        child: ChangeUserCard(
          label: 'Change Email',
          hintText: 'Enter your new email',
          controller: _emailController,
          btnName: 'Change Email',
          validator: (value) => MyValidator.validateEmail(context, value),
          onPressed: () {
            if (!isValid) return;

            context.read<SettingsCubit>().changeEmail(
              newEmail: _emailController.text.trim(),
            );

            context.push(
              RouteNames.verifyAccount,
              extra: RouteNames.changeEmail,
            );
          },
        ),
      ),
    );
  }
}
