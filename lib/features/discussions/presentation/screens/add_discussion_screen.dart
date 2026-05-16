import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/helpers/my_loaders.dart';
import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/services/user_cache_service.dart';
import '../../../../core/sync/retry_service.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../../generated/l10n.dart';
import '../../../../injection/injection_container.dart';
import '../../../home/domain/entities/paper_entity.dart';
import '../../../home/presentation/cubit/home_cubit.dart';
import '../../../interests/presentation/cubit/interests_cubit.dart';
import '../../data/models/discussion_author_model.dart';
import '../../data/models/discussion_model.dart';
import '../../domain/entities/create_discussion_params.dart';
import '../../domain/repositories/community_repository.dart';
import '../widgets/add_paper_bottom_sheet.dart';
import '../widgets/add_tag_bottom_sheet.dart';
import '../widgets/expandable_fab.dart';
import '../widgets/related_papers_section.dart';
import '../widgets/tags_section.dart';

class AddDiscussionScreen extends StatefulWidget {
  const AddDiscussionScreen({super.key});

  @override
  State<AddDiscussionScreen> createState() => _AddDiscussionScreenState();
}

class _AddDiscussionScreenState extends State<AddDiscussionScreen> {
  final titleController = TextEditingController();
  final bodyController = TextEditingController();

  final List<String> selectedTags = []; // Tag IDs only
  final List<String> selectedTagNames = []; // Corresponding names
  final List<PaperEntity> selectedPapers = [];
  bool isPosting = false;

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  bool get canPost =>
      titleController.text.isNotEmpty && bodyController.text.isNotEmpty;

  void removeTag(String tagName) {
    setState(() {
      final index = selectedTagNames.indexOf(tagName);
      if (index != -1) {
        selectedTags.removeAt(index);
        selectedTagNames.removeAt(index);
      }
    });
  }

  void removePaper(PaperEntity paper) {
    setState(() {
      selectedPapers.removeWhere((p) => p.id == paper.id);
    });
  }

  void addTag(String tagId, String tagName) {
    if (selectedTags.length < 5 && tagName.trim().isNotEmpty) {
      setState(() {
        selectedTags.add(tagId);
        selectedTagNames.add(tagName.trim());
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
        onAddTag: () => _showAddTagSheet(context),
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
                      onPressed: canPost && !isPosting
                          ? _submitDiscussion
                          : null,
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
                      child: isPosting
                          ? SizedBox(
                              width: ResponsiveHelper.responsiveValue(
                                context,
                                16,
                              ),
                              height: ResponsiveHelper.responsiveValue(
                                context,
                                16,
                              ),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              S.of(context).post_button,
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
                    hintText: S.of(context).title_hint,
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
                    hintText: S.of(context).discussion_body_hint,
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
                    tagNames: selectedTagNames,
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

  void _showAddTagSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider(
        create: (_) => sl<InterestsCubit>()..getAllInterests(),
        child: AddTagBottomSheet(
          onTagSelected: addTag,
          selectedTags: selectedTagNames,
        ),
      ),
    );
  }

  void _showAddPaperSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider.value(
        value: context.read<HomeCubit>(),
        child: AddPaperBottomSheet(
          onPaperSelected: addPaper,
          selectedPapers: selectedPapers,
        ),
      ),
    );
  }

  Future<void> _submitDiscussion() async {
    if (!canPost || isPosting) return;

    setState(() => isPosting = true);

    try {
      final params = CreateDiscussionParams(
        title: titleController.text.trim(),
        content: bodyController.text.trim(),
        topicIds: selectedTags,
        paperIds: selectedPapers.map((p) => p.id).toList(),
      );
      // Optimistic create: insert draft locally and enqueue for background sync
      final localId = 'local-${const Uuid().v4()}';

      final userCache = sl<UserCacheService>();
      final currentUser = userCache.getCachedUser();

      final author = DiscussionAuthorModel(
        id: currentUser?.id ?? '',
        username: currentUser?.username ?? '',
        fullName: currentUser?.fullName ?? '',
        photoUrl: currentUser?.photoURL,
        bio: '',
        role: 'USER',
        isPremium: false,
        isFollowing: false,
        isMe: true,
      );

      final draft = DiscussionModel(
        id: localId,
        title: params.title,
        content: params.content,
        upvoteCount: 0,
        downvoteCount: 0,
        commentCount: 0,
        authorId: author.id,
        paperIds: params.paperIds ?? [],
        papers: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        hasVoted: false,
        userVoteType: null,
        topics: [],
        author: author,
      );

      // Persist draft in cache so lists show it immediately
      await sl<CommunityRepository>().upsertCachedDiscussion(draft);

      // Enqueue for background sync
      await sl<RetryService>().enqueue('create_discussion', {
        'title': params.title,
        'content': params.content,
        'topicIds': params.topicIds,
        'paperIds': params.paperIds,
        'clientId': localId,
      });

      MyLoaders.successSnackBar(
        context: context,
        title: S.of(context).success,
        message: '${S.of(context).discussion_created_successfully} (pending)',
      );
      if (mounted) context.pop();

      setState(() => isPosting = false);
    } catch (e) {
      if (!mounted) return;
      setState(() => isPosting = false);
      MyLoaders.errorSnackBar(
        context: context,
        title: S.of(context).error_title,
        message: S.of(context).error_unexpected,
      );
    }
  }
}
