import 'package:equatable/equatable.dart';

import '../../domain/entities/user.dart';

abstract class ProfileHeaderState extends Equatable {
  const ProfileHeaderState();

  @override
  List<Object?> get props => [];
}

class ProfileHeaderInitial extends ProfileHeaderState {
  const ProfileHeaderInitial();
}

class ProfileHeaderLoading extends ProfileHeaderState {
  const ProfileHeaderLoading();
}

class ProfileHeaderLoaded extends ProfileHeaderState {
  final User user;
  final bool isFollowLoading;
  final String? message;

  const ProfileHeaderLoaded({
    required this.user,
    this.isFollowLoading = false,
    this.message,
  });

  ProfileHeaderLoaded copyWith({
    User? user,
    bool? isFollowLoading,
    String? message,
  }) {
    return ProfileHeaderLoaded(
      user: user ?? this.user,
      isFollowLoading: isFollowLoading ?? this.isFollowLoading,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [user, isFollowLoading, message];
}

class ProfileHeaderError extends ProfileHeaderState {
  final String message;

  const ProfileHeaderError({required this.message});

  @override
  List<Object?> get props => [message];
}
