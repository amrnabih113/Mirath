part of 'profile_cubit.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileLoadSuccess extends ProfileState {
  final User user;
  ProfileLoadSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

final class ProfileUpdating extends ProfileState {}

final class ProfileUpdateSuccess extends ProfileState {
  final User user;
  ProfileUpdateSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

final class ProfileFailure extends ProfileState {
  final String message;
  ProfileFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
