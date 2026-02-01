import 'package:flutter/material.dart';
import '../../../../../core/utils/my_colors.dart';
import '../../../../../core/utils/my_extenstions.dart';
import '../../../../../core/utils/my_logger.dart';
import '../../../../../core/utils/my_sizes.dart';
import '../../../domain/entities/comment.dart';
import 'comment_tile.dart';

class CommentsList extends StatelessWidget {
  final List<Comment> comments;

  const CommentsList({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    MyLogger.info(
      '[UI] 🎨 CommentsList building with ${comments.length} total comments',
    );

    // Filter top-level comments (no parent)
    final topLevelComments = comments.where((c) => c.parentId == null).toList();
    MyLogger.info(
      '[UI] 📋 Filtered to ${topLevelComments.length} top-level comments',
    );

    // Log pending comments
    final pendingComments = comments.where((c) => c.isPending).toList();
    if (pendingComments.isNotEmpty) {
      MyLogger.info(
        '[UI] ⏳ Found ${pendingComments.length} pending comments: ${pendingComments.map((c) => c.id).join(", ")}',
      );
    }

    if (topLevelComments.isEmpty) {
      MyLogger.info('[UI] ℹ️ No top-level comments, showing empty state');
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

    MyLogger.info('[UI] ✓ Building ${topLevelComments.length} comment tiles');
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
