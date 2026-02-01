import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/helpers/responsive_helper.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_sizes.dart';

class AddPaperBottomSheet extends StatelessWidget {
  const AddPaperBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MyColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            ResponsiveHelper.responsiveValue(context, 20),
          ),
          topRight: Radius.circular(
            ResponsiveHelper.responsiveValue(context, 20),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(MySizes.spaceMd(context)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add Paper',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.responsiveValue(context, 18),
                    fontWeight: FontWeight.w600,
                    color: MyColors.primaryShade900,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedCancel01,
                    size: ResponsiveHelper.responsiveValue(context, 24),
                    color: MyColors.primaryShade600,
                  ),
                ),
              ],
            ),
          ),
          // TODO: Implement paper search and selection list
          Padding(
            padding: EdgeInsets.all(MySizes.spaceMd(context)),
            child: Text(
              'Paper selection coming soon...',
              style: TextStyle(
                fontSize: ResponsiveHelper.responsiveValue(context, 14),
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          SizedBox(height: MySizes.spaceMd(context)),
        ],
      ),
    );
  }
}
