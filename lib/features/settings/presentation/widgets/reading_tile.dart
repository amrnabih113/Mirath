import 'package:flutter/material.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';

class ReadingTile extends StatefulWidget {
  const ReadingTile({super.key, required this.title, required this.items});
  final String title;
  final List<String> items;

  @override
  State<ReadingTile> createState() => _ReadingTileState();
}

class _ReadingTileState extends State<ReadingTile> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
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
              child: DropdownButton<String>(
                isExpanded: true,
                hint: Text(widget.items.first),
                value: selectedValue,
                underline: const SizedBox(),
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: MyColors.primaryShade800,
                  size: 25,
                ),

                dropdownColor: MyColors.primaryShade50,

                items: widget.items.map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: context.labelSmall.copyWith(
                        color: MyColors.black,
                        fontSize: 16,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedValue = value;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
