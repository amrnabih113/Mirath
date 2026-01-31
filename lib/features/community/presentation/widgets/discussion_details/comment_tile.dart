import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import '../../../../../core/helpers/responsive_helper.dart';
import '../../../../../core/services/user_cache_service.dart';
import '../../../../../core/utils/my_colors.dart';
import '../../../../../core/utils/my_extenstions.dart';
import '../../../../../core/utils/my_formaters.dart';
import '../../../../../core/utils/my_sizes.dart';
import '../../../../../injection/injection_container.dart';
import '../../../../auth/data/models/auth_user_data.dart';
import '../../../../common/widgets/profile_avatar.dart';
import '../../../domain/entities/comment.dart';
import '../../cubit/discussion_details_cubit.dart';
import '../../cubit/discussion_details_state.dart';
import 'vote_button.dart';

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

  List<Comment> get replies {
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
                              100,
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
                          Text(
                            'Sending...',
                            style: context.bodySmall.copyWith(
                              color: MyColors.textSecondary,
                              fontStyle: FontStyle.italic,
                            ),
                          )
                        else
                          Text(
                            widget.comment.createdAt.day ==
                                        DateTime.now().day &&
                                    widget.comment.createdAt.month ==
                                        DateTime.now().month &&
                                    widget.comment.createdAt.year ==
                                        DateTime.now().year &&
                                    widget.comment.createdAt.hour <=
                                        DateTime.now().hour + 1
                                ? MyFormaters.relativeTime(
                                    widget.comment.createdAt,
                                  )
                                : MyFormaters.formatDateTimeHours(
                                    widget.comment.createdAt,
                                  ),
                            style: context.bodySmall.copyWith(
                              color: MyColors.textSecondary,
                              fontSize: ResponsiveHelper.responsiveValue(
                                context,
                                10,
                              ),
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
                          child: VoteButton(
                            icon: HugeIconsStroke.arrowUp01,
                            count: widget.comment.upvoteCount,
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
                          child: VoteButton(
                            icon: HugeIconsStroke.arrowDown01,
                            count: widget.comment.downvoteCount,
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
                                final loadedState = isLoaded ? state : null;
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
                                        decoration: const InputDecoration(
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
                                      icon: Icon(
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
                      Text(
                        'Sending...',
                        style: context.bodySmall.copyWith(
                          color: MyColors.textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                      )
                    else
                      Text(
                        widget.comment.createdAt.day == DateTime.now().day
                            ? MyFormaters.relativeTime(widget.comment.createdAt)
                            : MyFormaters.formatDateTimeHours(
                                widget.comment.createdAt,
                              ),
                        style: context.bodySmall.copyWith(
                          color: MyColors.textSecondary,
                          fontSize: ResponsiveHelper.responsiveValue(
                            context,
                            10,
                          ),
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
                      child: VoteButton(
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
                      child: VoteButton(
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
