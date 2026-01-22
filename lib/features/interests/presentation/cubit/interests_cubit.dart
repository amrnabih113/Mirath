import 'package:bloc/bloc.dart';

import '../../../../core/usecases/no_params.dart';
import '../../domain/usecases/get_all_interests_usecase.dart';
import '../../domain/usecases/get_interest_by_id_usecase.dart';
import 'interests_state.dart';

class InterestsCubit extends Cubit<InterestsState> {
  final GetAllInterestsUsecase _getAllInterestsUsecase;
  final GetInterestByIdUsecase _getInterestByIdUsecase;

  InterestsCubit({
    required GetAllInterestsUsecase getAllInterestsUsecase,
    required GetInterestByIdUsecase getInterestByIdUsecase,
  }) : _getAllInterestsUsecase = getAllInterestsUsecase,
       _getInterestByIdUsecase = getInterestByIdUsecase,
       super(InterestsInitial());

  Future<void> getAllInterests() async {
    emit(InterestsLoading());

    final result = await _getAllInterestsUsecase(NoParams());

    result.fold(
      (failure) => emit(InterestsError(failure.message)),
      (interests) => emit(InterestsLoaded(interests)),
    );
  }

  Future<void> getInterestById(String id) async {
    emit(InterestsLoading());

    final result = await _getInterestByIdUsecase(id);

    result.fold(
      (failure) => emit(InterestsError(failure.message)),
      (interest) => emit(InterestLoaded(interest)),
    );
  }
}
