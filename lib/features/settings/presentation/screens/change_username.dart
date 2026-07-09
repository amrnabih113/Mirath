import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mirath/core/utils/my_validators.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:mirath/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:mirath/features/settings/presentation/widgets/change_user_card.dart';

class ChangeUsername extends StatefulWidget {
  const ChangeUsername({super.key, required this.oldUserName});
  final String oldUserName;

  @override
  State<ChangeUsername> createState() => _ChangeUsernameState();
}

class _ChangeUsernameState extends State<ChangeUsername> {
  final TextEditingController _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _usernameController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: MyBackIcon()),
      body: BlocConsumer<SettingsCubit, SettingsState>(
        listener: (context, state) {
          if (state is SettingsSuccess<String>) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.data)));
            context.read<ProfileCubit>().loadCurrentUser();
            context.pop();
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
              icon: Icons.alternate_email,
              label: 'Change Username',
              text: 'Your previous username is @${widget.oldUserName}',
              hintText: 'Enter your new username',
              controller: _usernameController,
              onPressed: () {
                if (isLoading) return;
                final username = _usernameController.text.trim();
                if (username.isEmpty) return;
                context.read<SettingsCubit>().changeUsername(
                  newUsername: username,
                );
              },
              btnName: 'Change Username',
              validator: (value) =>
                  MyValidator.usernameValidator(context, value),
            ),
          );
        },
      ),
    );
  }
}
