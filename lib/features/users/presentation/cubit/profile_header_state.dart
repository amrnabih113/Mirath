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

  const ProfileHeaderLoaded({required this.user});

  @override
  List<Object?> get props => [user];
}

class ProfileHeaderError extends ProfileHeaderState {
  final String message;

  const ProfileHeaderError({required this.message});

  @override
  List<Object?> get props => [message];
}
