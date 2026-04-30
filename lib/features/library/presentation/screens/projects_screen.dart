import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/library/presentation/widgets/show_create_list_dialog.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: MyBackIcon(),
        title: Text(
          'Your Projects',
          style: context.headlineLarge.copyWith(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedPlusSign,
              size: MySizes.iconMedium(context),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const CreateListDialog(),
              );
            },
          ),
        ],
      ),
    );
  }
}
