import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/utils/my_colors.dart';

class PaperCardItems extends StatelessWidget {
  const PaperCardItems({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: MyColors.primaryShade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: MyColors.primaryShade800, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'J. Phys. Commun. • 2022',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedBookmark02,
                    size: 25,
                    color: MyColors.primaryShade800,
                  ),
                ),
              ],
            ),
            Text(
              'What does it take to solve the measurement problem?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            Text(
              'Jonte R Hance and Sabine Hossenfelder',
              style: TextStyle(fontSize: 13, color: Colors.black),
            ),

            Wrap(
              spacing: 4,
              runSpacing: 6,
              children: [
                _tag('Quantum Mechanics'),
                _tag('The Measurement Problem'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _tag(String text) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: MyColors.primaryShade200,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 12,
        color: Colors.black,
        fontWeight: FontWeight.w400,
      ),
    ),
  );
}
