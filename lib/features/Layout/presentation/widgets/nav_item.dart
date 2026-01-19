import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_sizes.dart';

class NavItem extends StatelessWidget {
  final List<List<dynamic>> icon;
  final String label;
  final int index;
  final int currentIndex;
  final VoidCallback onTap;

  const NavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == currentIndex;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(MySizes.borderRadiusMd(context)),
        splashColor: MyColors.primaryShade800.withAlpha(10),
        highlightColor: MyColors.primaryShade800.withAlpha(5),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(
            horizontal: MySizes.spaceXs(context) * 0.5,
            vertical: MySizes.spaceXs(context) * 0.5,
          ),
          decoration: BoxDecoration(
            border: isSelected
                ? Border(
                    bottom: BorderSide(
                      color: MyColors.primaryShade700,
                      width: 3,
                      style: BorderStyle.solid,
                    ),
                  )
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HugeIcon(
                icon: icon,
                color: isSelected
                    ? MyColors.primaryShade800
                    : MyColors.primaryShade800.withAlpha(140),
                size: isSelected
                    ? MySizes.iconSmall(context) + 2
                    : MySizes.iconSmall(context),
              ),
              SizedBox(height: MySizes.spaceXs(context) * 0.3),
              if (isSelected)
                Text(
                  label,
                  style: TextStyle(
                    fontSize:
                        MySizes.bodySmall(context) -
                        ResponsiveHelper.responsiveValue(context, 3),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? MyColors.primaryShade800
                        : MyColors.primaryShade800.withAlpha(140),
                    letterSpacing: -0.4,
                    height: 1.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
