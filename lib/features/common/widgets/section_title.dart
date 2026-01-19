// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/features/home/presentation/widgets/see_all_button.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.title, this.showSeeAll = true});
  final String title;
  final bool showSeeAll;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: context.titleMedium.copyWith(
            fontWeight: FontWeight.w900,
            color: MyColors.black,
          ),
        ),
        if (showSeeAll) ...[Spacer(), SeeAllButton()],
      ],
    );
  }
}
