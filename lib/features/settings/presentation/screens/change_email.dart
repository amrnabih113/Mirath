import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mirath/core/constants/route_names.dart';
import 'package:mirath/core/utils/my_validators.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:mirath/features/settings/presentation/widgets/change_user_card.dart';

class ChangeEmail extends StatefulWidget {
  const ChangeEmail({super.key, required this.oldEmail});
  final String oldEmail;

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
      body: BlocConsumer<SettingsCubit, SettingsState>(
        listener: (context, state) {
          if (state is SettingsSuccess<String>) {
            context.push(
              RouteNames.confirmEmail,
              extra: _emailController.text.trim(),
            );
          } else if (state is SettingsFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errormessage)));
          }
        },
        builder: (context, state) {
          final isLoading = state is SettingsLoading;
          return Form(
            key: _formKey,
            child: ChangeUserCard(
              label: 'Change Email',
              text: 'Your previous email is ${widget.oldEmail}',
              hintText: 'Enter your new email',
              controller: _emailController,
              btnName: 'Change Email',
              validator: (value) => MyValidator.validateEmail(context, value),
              onPressed: () {
                if (isLoading) return;

                final isValid = _formKey.currentState!.validate();

                if (!isValid) return;

                context.read<SettingsCubit>().changeEmail(
                  newEmail: _emailController.text.trim(),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
