import 'package:flutter/material.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';

class DeleteButton extends StatefulWidget {
  const DeleteButton({super.key, this.onDelete, this.onDeleteAll});

  final Future<void> Function()? onDelete;
  final Future<void> Function()? onDeleteAll;

  @override
  State<DeleteButton> createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<DeleteButton> {
  String selectedValue = 'Delete';
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: MySizes.spaceXs(context),
        top: MySizes.spaceLg(context),
      ),
      child: PopupMenuButton<String>(
        initialValue: selectedValue,
        onSelected: (value) {
          setState(() {
            selectedValue = value;
          });

          if (value == 'Delete') {
            widget.onDelete?.call();
          } else if (value == 'Delete All') {
            widget.onDeleteAll?.call();
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'Delete',
            child: Text(
              'Delete',
              style: context.bodySmall.copyWith(
                color: MyColors.primaryShade900,
              ),
            ),
          ),
          PopupMenuItem(
            value: 'Delete All',
            child: Text(
              'Delete All',
              style: context.bodySmall.copyWith(
                color: MyColors.primaryShade900,
              ),
            ),
          ),
        ],
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(selectedValue, style: const TextStyle(color: Colors.black)),
              const SizedBox(width: 4),
              const Icon(Icons.keyboard_arrow_down, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
