import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/generated/l10n.dart';

class CreateListDialog extends StatefulWidget {
  const CreateListDialog({super.key});

  @override
  State<CreateListDialog> createState() => _CreateListDialogState();
}

class _CreateListDialogState extends State<CreateListDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  static const int maxLength = 100;
  bool isPublic = true;
  bool isTitleNotEmpty = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(S.of(context).create_list),
            IconButton(
              onPressed: () => context.pop(),
              icon: HugeIcon(icon: HugeIcons.strokeRoundedMultiplicationSign),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: buildInputDecoration(
                  labelText: S.of(context).list_title,
                ),
                onChanged: (value) {
                  setState(() {
                    isTitleNotEmpty = value.trim().isNotEmpty;
                  });
                },
              ),
              SizedBox(height: MySizes.spaceMd(context)),
              Stack(
                children: [
                  TextField(
                    controller: _descriptionController,
                    maxLines: 2,
                    maxLength: maxLength,
                    onChanged: (_) => setState(() {}),
                    decoration: buildInputDecoration(
                      labelText: S.of(context).description_optional,
                    ).copyWith(counterText: ""),
                  ),
                  Positioned(
                    right: 12,
                    bottom: 12,
                    child: Text(
                      '${_descriptionController.text.length}/$maxLength',
                      style: context.bodySmall.copyWith(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context).public_list,
                    style: context.bodyLarge.copyWith(color: MyColors.black),
                  ),
                  Transform.scale(
                    scale: 0.7,
                    child: Switch(
                      value: isPublic,
                      onChanged: (value) {
                        setState(() {
                          isPublic = value;
                        });
                      },
                      activeThumbColor: MyColors.primaryShade900,
                      thumbColor: WidgetStateProperty.all(
                        MyColors.primaryShade50,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MySizes.spaceSm(context)),
              TextButton(
                onPressed: () {
                  final title = _titleController.text;
                  final desc = _descriptionController.text;

                  print("Title: $title");
                  print("Description: $desc");
                  print("Is Public: $isPublic");

                  context.pop();
                },
                style: TextButton.styleFrom(
                  minimumSize: const Size(double.infinity, 40),
                  backgroundColor: isTitleNotEmpty
                      ? MyColors.primaryShade800
                      : MyColors.primaryShade800.withAlpha((255 * .5).toInt()),

                  foregroundColor: MyColors.primaryShade50,
                ),
                child: Text(S.of(context).create),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

InputDecoration buildInputDecoration({required String labelText}) {
  return InputDecoration(
    labelText: labelText,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: MyColors.primaryShade800),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: MyColors.primaryShade900),
    ),
  );
}
