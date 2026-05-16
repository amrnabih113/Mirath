import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/constants/route_names.dart';
import '../../../../core/services/sharing_service.dart';
import '../../../home/domain/entities/paper_entity.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import '../../../../generated/l10n.dart';
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
import '../../../../core/network/network_manager.dart';
import '../../../../core/ui/widgets/state_views.dart';
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
            title: S.of(context).error_title,
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
            final offline = !NetworkManager.instance.currentConnectionStatus;
            return Scaffold(
              body: offline
                  ? OfflineStateView(
                      title: 'Offline',
                      message: state.message,
                      actionLabel: 'Retry',
                      onAction: () {
                        final id = widget.discussionId ?? widget.discussion?.id;
                        if (id != null) {
                          context
                              .read<DiscussionDetailsCubit>()
                              .loadDiscussionDetails(id, forceRefresh: true);
                        }
                      },
                    )
                  : ErrorStateView(
                      title: 'Error',
                      message: state.message,
                      actionLabel: 'Retry',
                      onAction: () {
                        final id = widget.discussionId ?? widget.discussion?.id;
                        if (id != null) {
                          context
                              .read<DiscussionDetailsCubit>()
                              .loadDiscussionDetails(id, forceRefresh: true);
                        }
                      },
                    ),
            );
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

          return Scaffold(
            body: Center(child: Text(S.of(context).no_discussion_data)),
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
        title: S.of(context).warning_title,
        message: S.of(context).please_write_comment,
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
              onPressed: () {
                _showDiscussionMenu(context, discussion);
              },
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
                  child: RefreshIndicator(
                    onRefresh: () => context
                        .read<DiscussionDetailsCubit>()
                        .loadDiscussionDetails(
                          discussion.id,
                          forceRefresh: true,
                        ),
                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
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
                                  publishedAt: DateTime.now(),
                                  categories: [],
                                  isSaved: false,
                                  preprint: '',
                                  citation: '',
                                );
                                context.push(
                                  RouteNames.paperDetailsRoute(paperEntity.id),
                                  extra: paperEntity,
                                );
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
                                    hintText: S.of(context).comment_hint,
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
            ),
          );
        },
      ),
    );
  }

  void _showDiscussionMenu(BuildContext context, Discussion discussion) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const HugeIcon(icon: HugeIcons.strokeRoundedShare08),
              title: const Text('Share Discussion'),
              onTap: () {
                Navigator.pop(context);
                SharingService.shareDiscussion(discussion);
              },
            ),
          ],
        ),
      ),
    );
  }
}
