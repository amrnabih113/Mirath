import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mirath/core/network/network_manager.dart';
import 'package:mirath/features/users/domain/entities/user.dart';

import '../../../../core/usecases/no_params.dart';
import '../../../users/domain/usecases/users_cache_usecases.dart';
import '../../../users/domain/usecases/get_current_user_usecase.dart';
import '../../../users/domain/usecases/update_profile_usecase.dart';
import '../../../users/domain/entities/update_profile_data.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final UsersCacheUseCases usersCacheUseCases;
  final GetCurrentUserUsecase getCurrentUserUsecase;
  final UpdateProfileUsecase updateProfileUsecase;

  ProfileCubit({
    required this.usersCacheUseCases,
    required this.getCurrentUserUsecase,
    required this.updateProfileUsecase,
  }) : super(ProfileInitial());

  Future<void> loadCurrentUser({bool forceRefresh = false}) async {
    if (forceRefresh && !await NetworkManager.instance.isConnected) {
      return;
    }

    final cachedUser = await usersCacheUseCases.getCachedCurrentUser();

    if (cachedUser != null && !forceRefresh) {
      emit(ProfileLoadSuccess(user: cachedUser));
    } else {
      emit(ProfileLoading());
    }

    final result = await getCurrentUserUsecase(NoParams());
    result.fold(
      (failure) {
        if (cachedUser == null) {
          emit(ProfileFailure(message: failure.message));
        }
      },
      (user) {
        usersCacheUseCases.cacheCurrentUser(user);
        emit(ProfileLoadSuccess(user: user));
      },
    );
  }

  Future<void> updateProfile(UpdateProfileData data) async {
    emit(ProfileUpdating());
    final result = await updateProfileUsecase(data);
    result.fold(
      (failure) {
        emit(ProfileFailure(message: failure.message));
      },
      (user) {
        usersCacheUseCases.cacheCurrentUser(user);

        emit(ProfileUpdateSuccess(user: user));
      },
    );
  }
}
