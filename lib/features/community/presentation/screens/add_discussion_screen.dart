import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/helpers/responsive_helper.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_sizes.dart';
import 'package:mirath/features/home/domain/entities/paper_entity.dart';
import '../widgets/tags_section.dart';
import '../widgets/related_papers_section.dart';
import '../widgets/expandable_fab.dart';
import '../widgets/add_tag_dialog.dart';
import '../widgets/add_paper_bottom_sheet.dart';

class AddDiscussionScreen extends StatefulWidget {
  const AddDiscussionScreen({super.key});

  @override
  State<AddDiscussionScreen> createState() => _AddDiscussionScreenState();
}

class _AddDiscussionScreenState extends State<AddDiscussionScreen> {
  final titleController = TextEditingController();
  final bodyController = TextEditingController();

  final List<String> selectedTags = [];
  final List<PaperEntity> selectedPapers = [];

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  bool get canPost =>
      titleController.text.isNotEmpty && bodyController.text.isNotEmpty;

  void removeTag(String tag) {
    setState(() {
      selectedTags.remove(tag);
    });
  }

  void removePaper(PaperEntity paper) {
    setState(() {
      selectedPapers.removeWhere((p) => p.id == paper.id);
    });
  }

  void addTag(String tag) {
    if (selectedTags.length < 5 && tag.trim().isNotEmpty) {
      setState(() {
        selectedTags.add(tag.trim());
      });
    }
  }

  void addPaper(PaperEntity paper) {
    if (!selectedPapers.any((p) => p.id == paper.id)) {
      setState(() {
        selectedPapers.add(paper);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ExpandableFAB(
        onAddTag: () => _showAddTagDialog(context),
        onAddPaper: () => _showAddPaperSheet(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(MySizes.spaceMd(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar with close and post button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedCancel01,
                        size: ResponsiveHelper.responsiveValue(context, 28),
                        color: MyColors.primaryShade900,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: canPost ? () {} : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: canPost
                            ? MyColors.primaryColor
                            : MyColors.primaryShade300,
                        disabledBackgroundColor: MyColors.primaryShade300,
                        elevation: canPost ? 2 : 0,
                        padding: EdgeInsets.symmetric(
                          horizontal: MySizes.spaceMd(context),
                          vertical: MySizes.spaceXs(context),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            ResponsiveHelper.responsiveValue(context, 8),
                          ),
                        ),
                      ),
                      child: Text(
                        'Post',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: ResponsiveHelper.responsiveValue(
                            context,
                            14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MySizes.spaceLg(context)),

                // Title field
                TextField(
                  controller: titleController,
                  onChanged: (_) => setState(() {}),
                  cursorColor: MyColors.primaryShade500,
                  style: context.titleLarge.copyWith(
                    fontSize: ResponsiveHelper.responsiveValue(context, 20),
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Title',
                    hintStyle: context.titleLarge.copyWith(
                      fontSize: ResponsiveHelper.responsiveValue(context, 20),
                      color: MyColors.textPrimary.withValues(alpha: 0.6),
                    ),
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  maxLines: null,
                ),
                SizedBox(height: MySizes.spaceLg(context)),

                // Body field
                TextField(
                  controller: bodyController,
                  onChanged: (_) => setState(() {}),
                  cursorColor: MyColors.primaryShade500,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                      fontSize: ResponsiveHelper.responsiveValue(context, 12),
                      color: MyColors.textPrimary.withValues(alpha: 0.6),
                    ),
                    filled: false,
                    border: InputBorder.none,
                    hintText: 'What do you want to discuss?',
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  maxLines: null,
                ),

                // Tags section
                if (selectedTags.isNotEmpty) ...[
                  SizedBox(height: MySizes.spaceLg(context)),
                  TagsSection(
                    tags: selectedTags,
                    onRemoveTag: (tag) => removeTag(tag),
                  ),
                ],

                // Related Papers section
                if (selectedPapers.isNotEmpty) ...[
                  SizedBox(height: MySizes.spaceLg(context)),
                  RelatedPapersSection(
                    papers: selectedPapers,
                    onRemovePaper: (paper) => removePaper(paper),
                  ),
                ],

                SizedBox(height: 120), // Space for FAB
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddTagDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddTagDialog(
        currentTagCount: selectedTags.length,
        onTagAdded: addTag,
      ),
    );
  }

  void _showAddPaperSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddPaperBottomSheet(),
    );
  }
}
