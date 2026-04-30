/// Note Dialog Widget
///
/// Dialog for adding or editing notes on highlights
import 'package:flutter/material.dart';
import 'package:mirath/core/helpers/responsive_helper.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/core/utils/my_validators.dart';
import 'package:mirath/features/common/widgets/my_back_icon.dart';
import 'package:mirath/features/paper_annotations/presentation/widgets/annotation_equation_preview.dart';
import 'package:mirath/generated/l10n.dart';

class NoteDialog extends StatefulWidget {
  final String selectedText;
  final String? selectedHtmlContent;
  final String? selectedColorHex;
  final String? initialNote;
  final Function(String note) onSave;
  final Future<void> Function()? onDelete;

  const NoteDialog({
    super.key,
    required this.selectedText,
    this.selectedHtmlContent,
    this.selectedColorHex,
    this.initialNote,
    required this.onSave,
    this.onDelete,
  });

  @override
  State<NoteDialog> createState() => _NoteDialogState();
}

class _NoteDialogState extends State<NoteDialog> {
  late final TextEditingController _noteController;
  final _formKey = GlobalKey<FormState>();

  bool get _isEditing => widget.initialNote?.trim().isNotEmpty == true;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.initialNote);
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      widget.onSave(_noteController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedHex = widget.selectedColorHex;
    final previewHex = (selectedHex?.isNotEmpty == true)
        ? selectedHex
        : '#FFE082';
    final screenPadding = MySizes.paddingMd(context);
    final sectionSpacing = MySizes.spaceLg(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: Padding(
            padding: screenPadding,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final previewMaxHeight = constraints.maxHeight * 0.26;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        MyBackIcon(padding: false),
                        const Spacer(),
                        if (_isEditing)
                          TextButton(
                            onPressed: widget.onDelete == null
                                ? null
                                : () async {
                                    await widget.onDelete!.call();
                                  },
                            child: Text(
                              S.of(context).delete_note_button,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: sectionSpacing),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: previewMaxHeight),
                      child: AnnotationEquationPreview(
                        text: widget.selectedText,
                        htmlContent: widget.selectedHtmlContent,
                        highlightColorHex: previewHex,
                        maxLines: 4,
                        overflow: TextOverflow.visible,
                        textStyle: context.bodyLarge,
                      ),
                    ),
                    SizedBox(height: sectionSpacing),
                    Expanded(
                      child: TextFormField(
                        controller: _noteController,
                        maxLines: null,
                        expands: true,
                        autofocus: true,
                        style: context.bodyMedium,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          filled: false,
                          hintText: S.of(context).note_hint,
                          border: InputBorder.none,
                          isDense: true,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        validator: (note) => MyValidator.validateEmptyText(
                          context,
                          S.of(context).note_label,
                          note,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: _handleSave,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyColors.primaryShade700,
                          foregroundColor: Colors.white,
                          elevation: ResponsiveHelper.responsiveValue(
                            context,
                            2,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                MySizes.spaceXl(context) +
                                MySizes.spaceLg(context),
                            vertical: MySizes.spaceSm(context),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              MySizes.borderRadiusLg(context) * 20,
                            ),
                          ),
                        ),
                        child: Text(
                          S.of(context).save_button,
                          style: TextStyle(
                            fontSize: MySizes.titleLarge(context),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
