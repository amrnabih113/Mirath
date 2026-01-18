import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mirath/core/utils/my_colors.dart';

class CategoryItems extends StatelessWidget {
  CategoryItems({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(color: MyColors.primaryShade700),
          color: MyColors.primaryShade300,
          borderRadius: BorderRadius.circular(8),
        ),

        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Computer Science',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
    ;
  }
}
