import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mirath/features/users/domain/entities/user.dart';

import '../../../../core/usecases/no_params.dart';
import '../../../users/domain/usecases/get_current_user_usecase.dart';
import '../../../users/domain/usecases/update_profile_usecase.dart';
import '../../../users/domain/entities/update_profile_data.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetCurrentUserUsecase getCurrentUserUsecase;
  final UpdateProfileUsecase updateProfileUsecase;
  

  ProfileCubit({
    required this.getCurrentUserUsecase,
    required this.updateProfileUsecase,
  }) : super(ProfileInitial());

  Future<void> loadCurrentUser() async {
    emit(ProfileLoading());
    final result = await getCurrentUserUsecase(NoParams());
    result.fold(
      (failure) {
        emit(ProfileFailure(message: failure.message));
      },
      (user) {
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

        emit(ProfileUpdateSuccess(user: user));
      },
    );
  }
}
