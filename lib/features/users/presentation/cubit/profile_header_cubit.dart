import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/users_cache_usecases.dart';
import '../../domain/usecases/follow_user_usecase.dart';
import '../../domain/usecases/get_user_profile_header_usecase.dart';
import '../../domain/usecases/unfollow_user_usecase.dart';
import 'profile_header_state.dart';

class ProfileHeaderCubit extends Cubit<ProfileHeaderState> {
  final UsersCacheUseCases usersCacheUseCases;
  final GetUserProfileHeaderUsecase getUserProfileHeaderUsecase;
  final FollowUserUsecase followUserUsecase;
  final UnfollowUserUsecase unfollowUserUsecase;

  ProfileHeaderCubit({
    required this.usersCacheUseCases,
    required this.getUserProfileHeaderUsecase,
    required this.followUserUsecase,
    required this.unfollowUserUsecase,
  }) : super(const ProfileHeaderInitial());

  Future<void> getProfileHeader(String userId) async {
    final cachedUser = await usersCacheUseCases.getCachedUserProfileHeader(
      userId,
    );

    if (cachedUser != null) {
      emit(ProfileHeaderLoaded(user: cachedUser));
    } else {
      emit(const ProfileHeaderLoading());
    }

    final result = await getUserProfileHeaderUsecase(userId);

    result.fold(
      (failure) {
        if (cachedUser == null) {
          emit(
            const ProfileHeaderError(message: 'Failed to load user profile'),
          );
        }
      },
      (user) {
        usersCacheUseCases.cacheUserProfileHeader(user);
        emit(ProfileHeaderLoaded(user: user));
      },
    );
  }

  Future<void> followUser(String userId) async {
    final currentState = state;
    if (currentState is! ProfileHeaderLoaded) return;

    // Update UI immediately to show loading state
    emit(currentState.copyWith(isFollowLoading: true));

    final result = await followUserUsecase(userId);

    result.fold(
      (failure) {
        emit(
          currentState.copyWith(
            isFollowLoading: false,
            message: 'Failed to follow user',
          ),
        );
      },
      (_) {
        // Update user's isFollowed status
        final updatedUser = currentState.user.copyWith(isFollowed: true);
        usersCacheUseCases.updateCachedFollowState(
          userId: userId,
          isFollowing: true,
        );
        emit(ProfileHeaderLoaded(user: updatedUser));
      },
    );
  }

  Future<void> unfollowUser(String userId) async {
    final currentState = state;
    if (currentState is! ProfileHeaderLoaded) return;

    // Update UI immediately to show loading state
    emit(currentState.copyWith(isFollowLoading: true));

    final result = await unfollowUserUsecase(userId);

    result.fold(
      (failure) {
        emit(
          currentState.copyWith(
            isFollowLoading: false,
            message: 'Failed to unfollow user',
          ),
        );
      },
      (_) {
        // Update user's isFollowed status
        final updatedUser = currentState.user.copyWith(isFollowed: false);
        usersCacheUseCases.updateCachedFollowState(
          userId: userId,
          isFollowing: false,
        );
        emit(ProfileHeaderLoaded(user: updatedUser));
      },
    );
  }
}
