import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/features/home/domain/entities/paper_entity.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/services/user_cache_service.dart';
import '../../../../core/utils/my_colors.dart';
import '../../../../core/utils/my_extenstions.dart';
import '../../../../core/utils/my_logger.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../../core/helpers/my_loaders.dart';
import '../../../../injection/injection_container.dart';
import '../../../auth/data/models/auth_user_data.dart';
import '../../../common/widgets/my_back_icon.dart';
import '../../../common/widgets/tag_chip.dart';
import '../../domain/entities/discussion.dart';
import '../cubit/discussion_details_cubit.dart';
import '../cubit/discussion_details_state.dart';
import '../widgets/discussion_details/comments_list.dart';
import '../widgets/discussion_details_shimmer_loading.dart';
import '../widgets/disscusion_action_buttons.dart';
import '../widgets/disscussion_paper_card.dart';
import '../widgets/user_information_header.dart';

class DisscussionDetailsScreen extends StatefulWidget {
  final Discussion? discussion;
  final String? discussionId;

  const DisscussionDetailsScreen({
    super.key,
    this.discussion,
    this.discussionId,
  });

  @override
  State<DisscussionDetailsScreen> createState() =>
      _DisscussionDetailsScreenState();
}

class _DisscussionDetailsScreenState extends State<DisscussionDetailsScreen> {
  late TextEditingController _commentController;
  late AuthUserData? cachedUser;
  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();

    // Load discussion details
    if (widget.discussion != null) {
      // If we have a discussion, load its comments
      context.read<DiscussionDetailsCubit>().loadDiscussionDetails(
        widget.discussion!.id,
      );
    } else if (widget.discussionId != null) {
      // If we only have an ID, load full discussion details
      context.read<DiscussionDetailsCubit>().loadDiscussionDetails(
        widget.discussionId!,
      );
    }
    cachedUser = sl<UserCacheService>().getCachedUser();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DiscussionDetailsCubit, DiscussionDetailsState>(
      listener: (context, state) {
        if (state is DiscussionDetailsLoaded &&
            state.commentSubmissionError != null) {
          MyLoaders.errorSnackBar(
            context: context,
            title: 'Error',
            message: state.commentSubmissionError!,
          );
        }
      },
      child: BlocBuilder<DiscussionDetailsCubit, DiscussionDetailsState>(
        builder: (context, state) {
          if (state is DiscussionDetailsLoading) {
            return const DiscussionDetailsShimmerLoading();
          }

          if (state is DiscussionDetailsError) {
            return Scaffold(body: Center(child: Text(state.message)));
          }

          if (state is DiscussionDetailsLoaded) {
            return _buildDiscussionContent(context, state);
          }

          // If we already have discussion data, show it
          if (widget.discussion != null) {
            return _buildDiscussionContent(
              context,
              DiscussionDetailsLoaded(
                discussion: widget.discussion!,
                comments: [],
              ),
            );
          }

          return const Scaffold(
            body: Center(child: Text('No discussion data')),
          );
        },
      ),
    );
  }

  void _submitComment(BuildContext context, DiscussionDetailsLoaded state) {
    final content = _commentController.text.trim();
    MyLogger.info('[SCREEN] 📝 Submit button tapped, content: "$content"');

    if (content.isEmpty) {
      MyLogger.info('[SCREEN] ⚠️ Content is empty, showing snackbar');
      MyLoaders.warningSnackBar(
        context: context,
        title: 'Warning',
        message: 'Please write a comment',
      );
      return;
    }

    MyLogger.info(
      '[SCREEN] ✓ Calling addComment on cubit with discussionId=${state.discussion.id}',
    );
    context.read<DiscussionDetailsCubit>().addComment(
      discussionId: state.discussion.id,
      content: content,
    );

    MyLogger.info('[SCREEN] ✓ Clearing text controller');
    _commentController.clear();
  }

  Widget _buildDiscussionContent(
    BuildContext context,
    DiscussionDetailsLoaded state,
  ) {
    final discussion = state.discussion;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: ResponsiveHelper.responsiveValue(context, 50),
        leadingWidth: ResponsiveHelper.responsiveValue(context, 50),
        leading: MyBackIcon(),
        titleSpacing: 0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: MySizes.spaceSm(context)),
            child: IconButton(
              onPressed: () {},
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedMoreHorizontal,
                size: MySizes.iconMedium(context),
                strokeWidth: ResponsiveHelper.responsiveValue(context, 2),
              ),

              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 850),
              child: Padding(
                padding: MySizes.paddingMd(context),
                child: SafeArea(
                  bottom: false,
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: UserInformationHeader(
                          showMoreButton: false,
                          discussion: discussion,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(height: MySizes.spaceMd(context)),
                      ),
                      SliverToBoxAdapter(
                        child: Text(
                          discussion.title,
                          style: context.titleSmall.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(height: MySizes.spaceSm(context)),
                      ),
                      SliverToBoxAdapter(
                        child: Text(
                          discussion.content,
                          style: context.bodyMedium.copyWith(height: 1.5),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(height: MySizes.spaceMd(context)),
                      ),
                      if (discussion.papers.isNotEmpty)
                        SliverToBoxAdapter(
                          child: DisscussionPaperCard(
                            paper: discussion.papers.first,
                            onTap: () {
                              final discussionPaper = discussion.papers.first;
                              final paperEntity = PaperEntity(
                                id: discussionPaper.id,
                                title: discussionPaper.title,
                                abstract: discussionPaper.abstract,
                                authors: discussionPaper.authors,
                                publishedAt: '',
                                categories: [],
                                isSaved: false,
                                preprint: '',
                              );
                              context.push('/paper-screen', extra: paperEntity);
                            },
                          ),
                        ),
                      if (discussion.papers.isNotEmpty)
                        SliverToBoxAdapter(
                          child: SizedBox(height: MySizes.spaceMd(context)),
                        ),
                      SliverToBoxAdapter(
                        child: Wrap(
                          spacing: MySizes.spaceXs(context),
                          runSpacing: MySizes.spaceXs(context),
                          children: discussion.topics
                              .map((topic) => TagChip(label: topic.name))
                              .toList(),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(height: MySizes.spaceMd(context)),
                      ),
                      SliverToBoxAdapter(
                        child: DisscusionActionButtons(
                          discussion: discussion,
                          onVote: (voteType) {
                            context
                                .read<DiscussionDetailsCubit>()
                                .voteOnDiscussion(
                                  discussionId: discussion.id,
                                  voteType: voteType,
                                );
                          },
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(height: MySizes.spaceXs(context)),
                      ),
                      SliverToBoxAdapter(
                        child: Divider(color: MyColors.primaryShade700),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(height: MySizes.spaceSm(context)),
                      ),

                      SliverToBoxAdapter(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _commentController,
                                cursorColor: MyColors.primaryColor,
                                maxLines: 4,
                                minLines: 1,
                                decoration: InputDecoration(
                                  hintText: 'Write a comment...',
                                  errorText: state.commentSubmissionError,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => _submitComment(context, state),
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                HugeIconsStroke.sent,
                                size: MySizes.iconSmall(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(height: MySizes.spaceMd(context)),
                      ),
                      SliverToBoxAdapter(
                        child: CommentsList(comments: state.comments),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
