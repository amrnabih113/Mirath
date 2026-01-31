import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_user_profile_header_usecase.dart';
import 'profile_header_state.dart';

class ProfileHeaderCubit extends Cubit<ProfileHeaderState> {
  final GetUserProfileHeaderUsecase getUserProfileHeaderUsecase;

  ProfileHeaderCubit({required this.getUserProfileHeaderUsecase})
    : super(const ProfileHeaderInitial());

  Future<void> getProfileHeader(String userId) async {
    emit(const ProfileHeaderLoading());

    final result = await getUserProfileHeaderUsecase(userId);

    result.fold(
      (failure) {
        emit(const ProfileHeaderError(message: 'Failed to load user profile'));
      },
      (user) {
        emit(ProfileHeaderLoaded(user: user));
      },
    );
  }
}
