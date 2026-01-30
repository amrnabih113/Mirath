import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mirath/core/services/user_cache_service.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/core/utils/my_formaters.dart';
import 'package:mirath/features/auth/data/models/auth_user_data.dart';
import 'package:mirath/features/community/domain/entities/comment.dart';
import 'package:mirath/features/community/domain/entities/discussion.dart';
import 'package:mirath/features/community/presentation/cubit/discussion_details_cubit.dart';
import 'package:mirath/features/community/presentation/cubit/discussion_details_state.dart';
import 'package:mirath/features/community/presentation/widgets/discussion_card.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:mirath/features/common/widgets/profile_avatar.dart';
import 'package:mirath/features/community/presentation/widgets/disscusion_action_buttons.dart';
import 'package:mirath/features/community/presentation/widgets/disscussion_paper_card.dart';
import 'package:mirath/features/community/presentation/widgets/user_information_header.dart';
import 'package:mirath/injection/injection_container.dart';

import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../common/widgets/my_back_icon.dart';
import '../../../common/widgets/tag_chip.dart';

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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.commentSubmissionError!)),
          );
        }
      },
      child: BlocBuilder<DiscussionDetailsCubit, DiscussionDetailsState>(
        builder: (context, state) {
          if (state is DiscussionDetailsLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
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
    print('[SCREEN] 📝 Submit button tapped, content: "$content"');

    if (content.isEmpty) {
      print('[SCREEN] ⚠️ Content is empty, showing snackbar');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please write a comment')));
      return;
    }

    print(
      '[SCREEN] ✓ Calling addComment on cubit with discussionId=${state.discussion.id}',
    );
    context.read<DiscussionDetailsCubit>().addComment(
      discussionId: state.discussion.id,
      content: content,
    );

    print('[SCREEN] ✓ Clearing text controller');
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
                          style: context.bodyMedium.copyWith(
                            height: 1.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(height: MySizes.spaceMd(context)),
                      ),
                      if (discussion.paperIds.isNotEmpty)
                        SliverToBoxAdapter(
                          child: DisscussionPaperCard(
                            paperId: discussion.paperIds.first,
                          ),
                        ),
                      if (discussion.paperIds.isNotEmpty)
                        SliverToBoxAdapter(
                          child: SizedBox(height: MySizes.spaceMd(context)),
                        ),
                      SliverToBoxAdapter(
                        child: Wrap(
                          spacing: MySizes.spaceXs(context),
                          children: discussion.topics
                              .map((topic) => TagChip(label: topic.name))
                              .toList(),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(height: MySizes.spaceMd(context)),
                      ),
                      SliverToBoxAdapter(
                        child: DisscusionActionButtons(discussion: discussion),
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
                        child: _CommentsList(comments: state.comments),
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

class _CommentsList extends StatelessWidget {
  final List<Comment> comments;

  const _CommentsList({required this.comments});

  @override
  Widget build(BuildContext context) {
    print(
      '[UI] 🎨 _CommentsList building with ${comments.length} total comments',
    );

    // Filter top-level comments (no parent)
    final topLevelComments = comments.where((c) => c.parentId == null).toList();
    print('[UI] 📋 Filtered to ${topLevelComments.length} top-level comments');

    // Log pending comments
    final pendingComments = comments.where((c) => c.isPending).toList();
    if (pendingComments.isNotEmpty) {
      print(
        '[UI] ⏳ Found ${pendingComments.length} pending comments: ${pendingComments.map((c) => c.id).join(", ")}',
      );
    }

    if (topLevelComments.isEmpty) {
      print('[UI] ℹ️ No top-level comments, showing empty state');
      return Center(
        child: Padding(
          padding: EdgeInsets.all(MySizes.spaceMd(context)),
          child: Text(
            'No comments yet. Be the first to comment!',
            style: context.bodyMedium.copyWith(color: MyColors.textSecondary),
          ),
        ),
      );
    }

    print('[UI] ✓ Building ${topLevelComments.length} comment tiles');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: topLevelComments
          .map(
            (comment) => CommentTile(comment: comment, allComments: comments),
          )
          .toList(),
    );
  }
}

class CommentTile extends StatefulWidget {
  final Comment comment;
  final List<Comment> allComments;

  const CommentTile({
    super.key,
    required this.comment,
    required this.allComments,
  });

  @override
  State<CommentTile> createState() => CommentTileState();
}

class CommentTileState extends State<CommentTile> {
  bool isExpanded = false;
  bool isRepliesExpanded = false;
  bool isReplyingActive = false;
  late TextEditingController _replyController;
  late AuthUserData? cachedUser;

  @override
  void initState() {
    super.initState();
    _replyController = TextEditingController();
    cachedUser = sl<UserCacheService>().getCachedUser();
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  List<Comment> get _replies {
    // Only show replies for top-level comments (flatten nested replies)
    if (widget.comment.parentId != null) {
      return []; // Don't nest further
    }
    return widget.allComments
        .where((c) => c.parentId == widget.comment.id)
        .toList();
  }

  // Get all replies under the top-level comment (including nested ones)
  List<Comment> get _allRepliesFlattened {
    if (widget.comment.parentId != null) {
      return [];
    }
    // Get all comments that have this comment as ancestor
    final directReplies = widget.allComments
        .where((c) => c.parentId == widget.comment.id)
        .toList();

    final nestedReplies = <Comment>[];
    for (final reply in directReplies) {
      final repliesOfReply = widget.allComments
          .where((c) => c.parentId == reply.id)
          .toList();
      nestedReplies.addAll(repliesOfReply);
    }

    return [...directReplies, ...nestedReplies];
  }

  @override
  Widget build(BuildContext context) {
    final hasReplies =
        widget.comment.parentId == null && _allRepliesFlattened.isNotEmpty;

    return Container(
      margin: EdgeInsets.only(bottom: MySizes.spaceMd(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileAvatar(
                imageUrl: widget.comment.author.photoUrl,
                size: ResponsiveHelper.responsiveValue(context, 32),
              ),
              SizedBox(width: MySizes.spaceSm(context)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// HEADER
                    Row(
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: ResponsiveHelper.responsiveValue(
                              context,
                              120,
                            ),
                          ),
                          child: Text(
                            widget.comment.author.fullName,
                            overflow: TextOverflow.ellipsis,
                            style: context.bodyMedium.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: ResponsiveHelper.responsiveValue(
                                context,
                                14,
                              ),
                              color: MyColors.primaryShade900,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        if (widget.comment.isPending)
                          Row(
                            children: [
                              SizedBox(
                                width: 12,
                                height: 12,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    MyColors.textSecondary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Sending...',
                                style: context.bodySmall.copyWith(
                                  color: MyColors.textSecondary,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          )
                        else
                          Text(
                            MyFormaters.relativeTime(widget.comment.createdAt),
                            style: context.bodySmall.copyWith(
                              color: MyColors.textSecondary,
                            ),
                          ),
                        const Spacer(),
                        if (!widget.comment.isPending)
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              HugeIconsStroke.moreHorizontal,
                              size: MySizes.iconSmall(context) * 0.9,
                              color: MyColors.textSecondary,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                      ],
                    ),
                    SizedBox(height: MySizes.spaceXs(context) * 0.5),

                    /// COMMENT TEXT
                    _buildCommentText(context),

                    SizedBox(height: MySizes.spaceXs(context)),

                    /// ACTION ROW
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            context
                                .read<DiscussionDetailsCubit>()
                                .voteOnComment(
                                  commentId: widget.comment.id,
                                  voteType: 'UP',
                                );
                          },
                          child: _VoteButton(
                            icon: HugeIconsStroke.arrowUp01,
                            count: widget.comment.voteScore > 0
                                ? widget.comment.voteScore
                                : 0,
                            isVoted:
                                widget.comment.hasVoted &&
                                widget.comment.userVoteType == 'UP',
                            voteType: 'UP',
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            context
                                .read<DiscussionDetailsCubit>()
                                .voteOnComment(
                                  commentId: widget.comment.id,
                                  voteType: 'DOWN',
                                );
                          },
                          child: _VoteButton(
                            icon: HugeIconsStroke.arrowDown01,
                            count: widget.comment.voteScore < 0
                                ? -widget.comment.voteScore
                                : 0,
                            isVoted:
                                widget.comment.hasVoted &&
                                widget.comment.userVoteType == 'DOWN',
                            voteType: 'DOWN',
                          ),
                        ),
                        const SizedBox(width: 14),
                        if (hasReplies)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isRepliesExpanded = !isRepliesExpanded;
                              });
                            },
                            child: Row(
                              children: [
                                Icon(
                                  HugeIconsStroke.comment01,
                                  size: MySizes.iconSmall(context) * 0.9,
                                  color: MyColors.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _allRepliesFlattened.length.toString(),
                                  style: context.bodySmall.copyWith(
                                    color: MyColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(width: 12),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isReplyingActive = !isReplyingActive;
                            });
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Reply',
                            style: context.bodySmall.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),

                    /// REPLY TEXT FIELD
                    if (isReplyingActive)
                      Padding(
                        padding: EdgeInsets.only(top: MySizes.spaceSm(context)),
                        child:
                            BlocBuilder<
                              DiscussionDetailsCubit,
                              DiscussionDetailsState
                            >(
                              builder: (context, state) {
                                final isLoaded =
                                    state is DiscussionDetailsLoaded;
                                final loadedState = isLoaded
                                    ? state as DiscussionDetailsLoaded
                                    : null;
                                final isSubmitting =
                                    loadedState?.isSubmittingComment ?? false;

                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ProfileAvatar(
                                      imageUrl: cachedUser?.photoURL ?? '',
                                      size: ResponsiveHelper.responsiveValue(
                                        context,
                                        28,
                                      ),
                                    ),
                                    SizedBox(width: MySizes.spaceSm(context)),
                                    Expanded(
                                      child: TextField(
                                        controller: _replyController,
                                        cursorColor: MyColors.primaryColor,
                                        maxLines: 3,
                                        minLines: 1,
                                        enabled: !isSubmitting,
                                        decoration: InputDecoration(
                                          hintText: 'Write a reply...',
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: MySizes.spaceSm(context)),
                                    IconButton(
                                      onPressed: isLoaded && !isSubmitting
                                          ? () => _submitReply(
                                              context,
                                              loadedState!,
                                            )
                                          : null,
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      icon: isSubmitting
                                          ? SizedBox(
                                              width:
                                                  MySizes.iconSmall(context) *
                                                  0.8,
                                              height:
                                                  MySizes.iconSmall(context) *
                                                  0.8,
                                              child:
                                                  const CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                  ),
                                            )
                                          : Icon(
                                              HugeIconsStroke.sent,
                                              size: MySizes.iconSmall(context),
                                            ),
                                    ),
                                  ],
                                );
                              },
                            ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          /// REPLIES (flattened - only one level)
          if (isRepliesExpanded && _allRepliesFlattened.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(
                top: MySizes.spaceSm(context),
                left: MySizes.spaceLg(context),
              ),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: MyColors.primaryShade700,
                      width: 1.2,
                    ),
                  ),
                ),
                padding: EdgeInsets.only(left: MySizes.spaceMd(context)),
                child: Column(
                  children: _allRepliesFlattened
                      .map((reply) => _buildReplyTile(context, reply))
                      .toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _submitReply(BuildContext context, DiscussionDetailsLoaded state) {
    final content = _replyController.text.trim();
    if (content.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please write a reply')));
      return;
    }

    context.read<DiscussionDetailsCubit>().addComment(
      discussionId: state.discussion.id,
      content: content,
      parentId: widget.comment.id,
    );

    _replyController.clear();
    setState(() {
      isReplyingActive = false;
    });
  }

  Widget _buildReplyTile(BuildContext context, Comment reply) {
    // Get parent comment to show mention if needed
    Comment? parentComment;
    if (reply.parentId != null) {
      try {
        parentComment = widget.allComments.firstWhere(
          (c) => c.id == reply.parentId,
        );
      } catch (e) {
        parentComment = null;
      }
    }

    final isReplyToReply =
        parentComment != null && parentComment.parentId != null;
    final mentionedAuthor = isReplyToReply
        ? parentComment.author.username
        : null;

    return Container(
      margin: EdgeInsets.only(bottom: MySizes.spaceMd(context)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileAvatar(
            imageUrl: reply.author.photoUrl,
            size: ResponsiveHelper.responsiveValue(context, 32),
          ),
          SizedBox(width: MySizes.spaceSm(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// HEADER
                Row(
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: ResponsiveHelper.responsiveValue(
                          context,
                          100,
                        ),
                      ),
                      child: Text(
                        reply.author.fullName,
                        overflow: TextOverflow.ellipsis,
                        style: context.bodyMedium.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    if (reply.isPending)
                      Row(
                        children: [
                          SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                MyColors.textSecondary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Sending...',
                            style: context.bodySmall.copyWith(
                              color: MyColors.textSecondary,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      )
                    else
                      Text(
                        MyFormaters.relativeTime(reply.createdAt),
                        style: context.bodySmall.copyWith(
                          color: MyColors.textSecondary,
                        ),
                      ),
                    const Spacer(),
                    if (!reply.isPending)
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          HugeIconsStroke.moreHorizontal,
                          size: MySizes.iconSmall(context) * 0.9,
                          color: MyColors.textSecondary,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                  ],
                ),
                SizedBox(height: MySizes.spaceXs(context) * 0.5),

                /// REPLY TEXT with mention
                if (mentionedAuthor != null)
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '@$mentionedAuthor ',
                          style: context.bodyMedium.copyWith(
                            color: MyColors.primaryColor,
                            fontWeight: FontWeight.w600,
                            height: 1.45,
                          ),
                        ),
                        TextSpan(
                          text: reply.content,
                          style: context.bodyMedium.copyWith(height: 1.45),
                        ),
                      ],
                    ),
                  )
                else
                  Text(
                    reply.content,
                    style: context.bodyMedium.copyWith(height: 1.45),
                  ),
                SizedBox(height: MySizes.spaceXs(context)),

                /// ACTION ROW
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.read<DiscussionDetailsCubit>().voteOnComment(
                          commentId: reply.id,
                          voteType: 'UP',
                        );
                      },
                      child: _VoteButton(
                        icon: HugeIconsStroke.arrowUp01,
                        count: reply.voteScore > 0 ? reply.voteScore : 0,
                        isVoted: reply.hasVoted && reply.userVoteType == 'UP',
                        voteType: 'UP',
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        context.read<DiscussionDetailsCubit>().voteOnComment(
                          commentId: reply.id,
                          voteType: 'DOWN',
                        );
                      },
                      child: _VoteButton(
                        icon: HugeIconsStroke.arrowDown01,
                        count: reply.voteScore < 0 ? -reply.voteScore : 0,
                        isVoted: reply.hasVoted && reply.userVoteType == 'DOWN',
                        voteType: 'DOWN',
                      ),
                    ),
                    const SizedBox(width: 12),
                    TextButton(
                      onPressed: () {
                        // Reply to this reply - will show mention
                        _replyToComment(context, reply);
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Reply',
                        style: context.bodySmall.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _replyToComment(BuildContext context, Comment targetComment) {
    // Scroll to main comment reply field and focus it
    setState(() {
      isReplyingActive = true;
    });
    // The parent ID should be the target comment ID for backend
    // This will make the API create the proper parent-child relationship
  }

  Widget _buildCommentText(BuildContext context) {
    const maxLength = 120;
    final text = widget.comment.content;
    final hasMore = text.length > maxLength && !isExpanded;

    final textStyle = context.bodyMedium.copyWith(
      height: 1.45,
      fontWeight: FontWeight.w500,
    );

    // Check if this is a reply to a reply (parent has a parent)
    Comment? parentComment;
    if (widget.comment.parentId != null) {
      try {
        parentComment = widget.allComments.firstWhere(
          (c) => c.id == widget.comment.parentId,
        );
      } catch (e) {
        parentComment = null;
      }
    }

    final isReplyToReply =
        parentComment != null && parentComment.parentId != null;
    final mentionedAuthor = isReplyToReply
        ? parentComment.author.username
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (mentionedAuthor != null)
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '@$mentionedAuthor ',
                  style: textStyle.copyWith(
                    color: MyColors.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: hasMore ? '${text.substring(0, maxLength)}...' : text,
                  style: textStyle,
                ),
              ],
            ),
          )
        else
          Text(
            hasMore ? '${text.substring(0, maxLength)}...' : text,
            style: textStyle,
          ),
        if (hasMore)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              setState(() {
                isExpanded = true;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                'more',
                style: context.bodySmall.copyWith(
                  color: MyColors.primaryShade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// VOTE BUTTON
class _VoteButton extends StatelessWidget {
  final IconData icon;
  final int count;
  final bool isVoted;
  final String? voteType; // 'UP' or 'DOWN'

  const _VoteButton({
    required this.icon,
    required this.count,
    this.isVoted = false,
    this.voteType,
  });

  @override
  Widget build(BuildContext context) {
    late final Color buttonColor;

    if (!isVoted) {
      buttonColor = MyColors.textSecondary;
    } else {
      // Different colors for UP vote (green) and DOWN vote (redish pink)
      if (voteType == 'UP') {
        buttonColor = MyColors.success; // Green color
      } else if (voteType == 'DOWN') {
        buttonColor = const Color(0xFFE94B8F); // Redish pink color
      } else {
        buttonColor = MyColors.primaryColor; // Default fallback
      }
    }

    return Row(
      children: [
        Icon(icon, size: MySizes.iconSmall(context), color: buttonColor),
        const SizedBox(width: 4),
        Text(
          count.toString(),
          style: context.bodySmall.copyWith(color: buttonColor),
        ),
      ],
    );
  }
}
