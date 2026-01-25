import 'package:flutter/material.dart';
import 'package:mirath/core/utils/my_colors.dart';
import 'package:mirath/core/utils/my_extenstions.dart';
import 'package:mirath/features/community/presentation/widgets/discussion_card.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:mirath/features/common/widgets/profile_avatar.dart';

import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/utils/my_sizes.dart';
import '../../../common/widgets/my_back_icon.dart';
import '../widgets/tag_chip.dart';

class DisscussionDetailsScreen extends StatelessWidget {
  const DisscussionDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final comments = mockComments;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: ResponsiveHelper.responsiveValue(context, 50),
        leadingWidth: ResponsiveHelper.responsiveValue(context, 50),
        leading: MyBackIcon(),
        titleSpacing: 0,
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
                        child: UserInformationHeader(showMoreButton: false),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(height: MySizes.spaceMd(context)),
                      ),
                      SliverToBoxAdapter(
                        child: Text(
                          'Quantum Computing and Cybersecurity',
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
                          'Quantum computing is an emerging technology that leverages the principles of quantum mechanics to perform computations at speeds unattainable by classical computers. As quantum computers become more powerful, they pose significant challenges to traditional cybersecurity measures, particularly in the realm of encryption. This discussion explores the implications of quantum computing on cybersecurity, including potential threats and strategies for mitigation. The conversation will cover topics such as quantum-resistant algorithms, the timeline for quantum advancements, and the role of governments and organizations in preparing for a quantum future.',
                          style: context.bodyMedium.copyWith(
                            height: 1.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(height: MySizes.spaceMd(context)),
                      ),
                      const SliverToBoxAdapter(child: DisscussionPaperCard()),
                      SliverToBoxAdapter(
                        child: SizedBox(height: MySizes.spaceMd(context)),
                      ),
                      SliverToBoxAdapter(
                        child: Wrap(
                          spacing: MySizes.spaceXs(context),
                          children: [
                            TagChip(label: 'Quantum Computing'),
                            TagChip(label: 'Cybersecurity'),
                          ],
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(height: MySizes.spaceMd(context)),
                      ),
                      SliverToBoxAdapter(child: DisscusionActionButtons()),
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
                                cursorColor: MyColors.primaryColor,
                                maxLines: 4,
                                minLines: 1,
                                decoration: InputDecoration(
                                  hintText: 'Write a comment...',
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
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
                        child: CommentList(comments: comments),
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

class CommentList extends StatelessWidget {
  const CommentList({super.key, required this.comments});
  final List<CommentNode> comments;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...comments.map((c) => CommentTile(node: c, isNested: false)),
        Padding(
          padding: EdgeInsets.only(top: MySizes.spaceXs(context)),
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'See more replies',
              style: context.bodyMedium.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }
}

class CommentTile extends StatefulWidget {
  const CommentTile({super.key, required this.node, required this.isNested});

  final CommentNode node;
  final bool isNested;

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  bool isExpanded = false;
  bool isRepliesExpanded = false;
  bool isReplyingActive = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: MySizes.spaceMd(context),
        left: widget.isNested ? MySizes.spaceLg(context) : 0,
      ),
      decoration: widget.isNested
          ? BoxDecoration(
              border: Border(
                left: BorderSide(color: MyColors.primaryShade700, width: 1.2),
              ),
            )
          : null,
      padding: EdgeInsets.only(
        left: widget.isNested ? MySizes.spaceMd(context) : 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileAvatar(
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
                        Text(
                          widget.node.author,
                          style: context.bodyMedium.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          widget.node.time,
                          style: context.bodySmall.copyWith(
                            color: MyColors.textSecondary,
                          ),
                        ),
                        const Spacer(),
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
                        _VoteButton(
                          icon: HugeIconsStroke.arrowUp01,
                          count: widget.node.upVotes,
                        ),
                        const SizedBox(width: 12),
                        _VoteButton(
                          icon: HugeIconsStroke.arrowDown01,
                          count: widget.node.downVotes,
                        ),
                        const SizedBox(width: 14),
                        if (widget.node.replies.isNotEmpty)
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
                                  widget.node.commentCount.toString(),
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
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ProfileAvatar(
                              size: ResponsiveHelper.responsiveValue(
                                context,
                                28,
                              ),
                            ),
                            SizedBox(width: MySizes.spaceSm(context)),
                            Expanded(
                              child: TextField(
                                cursorColor: MyColors.primaryColor,
                                maxLines: 3,
                                minLines: 1,
                                decoration: InputDecoration(
                                  hintText: 'Write a reply...',
                                ),
                              ),
                            ),
                            SizedBox(width: MySizes.spaceSm(context)),
                            IconButton(
                              onPressed: () {},
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: Icon(
                                HugeIconsStroke.sent,
                                size: MySizes.iconSmall(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          /// REPLIES (Hidden by default, shown when comment icon clicked)
          if (isRepliesExpanded && widget.node.replies.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: MySizes.spaceSm(context)),
              child: Column(
                children: widget.node.replies
                    .map((reply) => CommentTile(node: reply, isNested: true))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCommentText(BuildContext context) {
    const maxLength = 120;
    final text = widget.node.text;
    final hasMore = text.length > maxLength && !isExpanded;

    final textStyle = context.bodyMedium.copyWith(height: 1.45);

    if (widget.node.mentionedUser != null &&
        widget.node.mentionedUser!.isNotEmpty) {
      return RichText(
        text: TextSpan(
          style: textStyle,
          children: [
            TextSpan(
              text: '${widget.node.mentionedUser} ',
              style: textStyle.copyWith(
                color: const Color(0xFF4A9EFF),
                fontWeight: FontWeight.w700,
              ),
            ),
            TextSpan(
              text: hasMore ? '${text.substring(0, maxLength)}...' : text,
            ),
            if (hasMore)
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      setState(() {
                        isExpanded = true;
                      });
                    },
                    child: Text(
                      'more',
                      style: context.bodySmall.copyWith(
                        color: MyColors.primaryShade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
  const _VoteButton({required this.icon, required this.count});

  final IconData icon;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: MySizes.iconSmall(context),
          color: MyColors.textSecondary,
        ),
        const SizedBox(width: 4),
        Text(
          count.toString(),
          style: context.bodySmall.copyWith(color: MyColors.textSecondary),
        ),
      ],
    );
  }
}

/// DATA MODEL
class CommentNode {
  CommentNode({
    required this.author,
    required this.time,
    required this.text,
    required this.upVotes,
    required this.downVotes,
    required this.commentCount,
    this.mentionedUser,
    this.replies = const [],
  });

  final String author;
  final String time;
  final String text;
  final int upVotes;
  final int downVotes;
  final int commentCount;
  final String? mentionedUser;
  final List<CommentNode> replies;
}

/// MOCK DATA
final List<CommentNode> mockComments = [
  CommentNode(
    author: 'Jane Doe',
    time: '11h',
    text:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque ante dui, lobortis sed orci vitae, molestie convallis justo.',
    upVotes: 12,
    downVotes: 0,
    commentCount: 4,
    replies: [
      CommentNode(
        author: 'John Smith',
        time: '10h',
        text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
        upVotes: 2,
        downVotes: 0,
        commentCount: 1,
      ),
      CommentNode(
        author: 'Jane Doe',
        time: '9h',
        text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
        upVotes: 1,
        downVotes: 0,
        commentCount: 1,
        mentionedUser: 'John Smith',
      ),
    ],
  ),
  CommentNode(
    author: 'Jane Doe',
    time: '11h',
    text:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque ante dui, lobortis sed orci vitae, molestie convallis justo.',
    upVotes: 12,
    downVotes: 0,
    commentCount: 4,
    replies: [
      CommentNode(
        author: 'John Smith',
        time: '10h',
        text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
        upVotes: 2,
        downVotes: 0,
        commentCount: 1,
      ),
      CommentNode(
        author: 'Jane Doe',
        time: '9h',
        text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
        upVotes: 1,
        downVotes: 0,
        commentCount: 1,
        mentionedUser: 'John Smith',
      ),
    ],
  ),
];
