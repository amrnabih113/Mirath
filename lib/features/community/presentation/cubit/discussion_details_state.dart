import 'package:equatable/equatable.dart';
import 'package:mirath/features/community/domain/entities/comment.dart';
import 'package:mirath/features/community/domain/entities/discussion.dart';

abstract class DiscussionDetailsState extends Equatable {
  const DiscussionDetailsState();

  @override
  List<Object?> get props => [];
}

class DiscussionDetailsInitial extends DiscussionDetailsState {
  const DiscussionDetailsInitial();
}

class DiscussionDetailsLoading extends DiscussionDetailsState {
  const DiscussionDetailsLoading();
}

class DiscussionDetailsLoaded extends DiscussionDetailsState {
  final Discussion discussion;
  final List<Comment> comments;
  final bool isLoadingComments;
  final bool isSubmittingComment;
  final String? commentSubmissionError;

  const DiscussionDetailsLoaded({
    required this.discussion,
    required this.comments,
    this.isLoadingComments = false,
    this.isSubmittingComment = false,
    this.commentSubmissionError,
  });

  DiscussionDetailsLoaded copyWith({
    Discussion? discussion,
    List<Comment>? comments,
    bool? isLoadingComments,
    bool? isSubmittingComment,
    String? commentSubmissionError,
  }) {
    return DiscussionDetailsLoaded(
      discussion: discussion ?? this.discussion,
      comments: comments ?? this.comments,
      isLoadingComments: isLoadingComments ?? this.isLoadingComments,
      isSubmittingComment: isSubmittingComment ?? this.isSubmittingComment,
      commentSubmissionError: commentSubmissionError,
    );
  }

  @override
  List<Object?> get props => [
    discussion,
    comments,
    isLoadingComments,
    isSubmittingComment,
    commentSubmissionError,
  ];
}

class DiscussionDetailsError extends DiscussionDetailsState {
  final String message;

  const DiscussionDetailsError({required this.message});

  @override
  List<Object?> get props => [message];
}
