import 'package:flutter/material.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/settings/presentation/widgets/change_user_card.dart';

class ChangeUsername extends StatefulWidget {
  const ChangeUsername({super.key});

  @override
  State<ChangeUsername> createState() => _ChangeUsernameState();
}

class _ChangeUsernameState extends State<ChangeUsername> {
  final TextEditingController _usernameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _usernameController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: MyBackIcon()),
      body: ChangeUserCard(
        label: 'Change Username',
        hintText: 'Enter your new username',
        controller: _usernameController,
        onPressed: () {},
        btnName: 'Change Username',
      ),
    );
  }
}
