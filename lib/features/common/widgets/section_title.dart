import 'package:flutter/material.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/features/home/presentation/widgets/see_all_button.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.title, this.showSeeAll = true, this.onTap});
  final String title;
  final bool showSeeAll;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: context.titleMedium.copyWith(fontWeight: FontWeight.w900),
        ),
        if (showSeeAll) ...[Spacer(), SeeAllButton(onTap: onTap)],
      ],
    );
  }
}
