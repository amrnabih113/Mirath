import 'package:flutter/material.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';

class ReadingTile<T> extends StatelessWidget {
  const ReadingTile({
    super.key,
    required this.title,
    required this.items,
    required this.selectedValue,
    this.onChanged,
    required this.itemLabel,
  });
  final String title;
  final List<T> items;
  final T selectedValue;
   final String Function(T item) itemLabel;
  final void Function(T?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            softWrap: true,
            style: context.bodyLarge.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              overflow: TextOverflow.visible,
            ),
          ),
          SizedBox(width: MySizes.spaceLg(context)),
          Flexible(
            child: Container(
              width: 156,
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(16),
                color: MyColors.primaryShade50,
              ),
              child: DropdownButton<T>(
                isExpanded: true,
                hint: Text(items.first.toString()),
                value: selectedValue,
                underline: const SizedBox(),
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: MyColors.primaryShade800,
                  size: 25,
                ),

                dropdownColor: MyColors.primaryShade50,

                items: items.map((item) {
                  return DropdownMenuItem<T>(
                    value: item,
                    child: Text(
                      itemLabel(item),
                      style: context.labelSmall.copyWith(
                        color: MyColors.black,
                        fontSize: 16,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
