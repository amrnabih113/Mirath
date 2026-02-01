import 'package:flutter/material.dart';
import 'package:mirath/core/helpers/responsive_helper.dart';
import 'package:mirath/core/utils/my_colors.dart';

class AddTagDialog extends StatefulWidget {
  final int currentTagCount;
  final Function(String tag) onTagAdded;

  const AddTagDialog({
    super.key,
    required this.currentTagCount,
    required this.onTagAdded,
  });

  @override
  State<AddTagDialog> createState() => _AddTagDialogState();
}

class _AddTagDialogState extends State<AddTagDialog> {
  final tagController = TextEditingController();

  @override
  void dispose() {
    tagController.dispose();
    super.dispose();
  }

  bool get canAddTag =>
      widget.currentTagCount < 5 && tagController.text.trim().isNotEmpty;

  void _addTag() {
    if (canAddTag) {
      widget.onTagAdded(tagController.text);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: MyColors.light,
      title: Text(
        'Add Tag',
        style: TextStyle(
          fontSize: ResponsiveHelper.responsiveValue(context, 18),
          fontWeight: FontWeight.w600,
          color: MyColors.primaryShade900,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tags help your discussion reach more people',
            style: TextStyle(
              fontSize: ResponsiveHelper.responsiveValue(context, 12),
              color: MyColors.primaryShade600,
            ),
          ),
          SizedBox(height: ResponsiveHelper.responsiveValue(context, 16)),
          TextField(
            controller: tagController,
            cursorColor: MyColors.primaryShade500,
            decoration: InputDecoration(
              hintText: 'Enter tag name',
              hintStyle: TextStyle(
                color: MyColors.primaryShade400,
                fontSize: ResponsiveHelper.responsiveValue(context, 13),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.responsiveValue(context, 8),
                ),
                borderSide: BorderSide(color: MyColors.primaryShade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.responsiveValue(context, 8),
                ),
                borderSide: BorderSide(color: MyColors.primaryShade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.responsiveValue(context, 8),
                ),
                borderSide: BorderSide(color: MyColors.primaryColor, width: 2),
              ),
            ),
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) => _addTag(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(color: MyColors.primaryShade600),
          ),
        ),
        ElevatedButton(
          onPressed: canAddTag ? _addTag : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: canAddTag
                ? MyColors.primaryColor
                : MyColors.primaryShade300,
            disabledBackgroundColor: MyColors.primaryShade300,
          ),
          child: Text(
            'Add',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
