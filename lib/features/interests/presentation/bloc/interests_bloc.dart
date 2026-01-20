import 'package:bloc/bloc.dart';

import '../../../../core/usecases/no_params.dart';
import '../../domain/usecases/get_all_interests_usecase.dart';
import '../../domain/usecases/get_interest_by_id_usecase.dart';
import 'interests_event.dart';
import 'interests_state.dart';

class InterestsBloc extends Bloc<InterestsEvent, InterestsState> {
  final GetAllInterestsUsecase _getAllInterestsUsecase;
  final GetInterestByIdUsecase _getInterestByIdUsecase;

  InterestsBloc({
    required GetAllInterestsUsecase getAllInterestsUsecase,
    required GetInterestByIdUsecase getInterestByIdUsecase,
  }) : _getAllInterestsUsecase = getAllInterestsUsecase,
       _getInterestByIdUsecase = getInterestByIdUsecase,
       super(InterestsInitial()) {
    on<GetAllInterestsEvent>(_onGetAllInterests);
    on<GetInterestByIdEvent>(_onGetInterestById);
  }

  Future<void> _onGetAllInterests(
    GetAllInterestsEvent event,
    Emitter<InterestsState> emit,
  ) async {
    emit(InterestsLoading());

    final result = await _getAllInterestsUsecase(NoParams());

    result.fold(
      (failure) => emit(InterestsError(failure.message)),
      (interests) => emit(InterestsLoaded(interests)),
    );
  }

  Future<void> _onGetInterestById(
    GetInterestByIdEvent event,
    Emitter<InterestsState> emit,
  ) async {
    emit(InterestsLoading());

    final result = await _getInterestByIdUsecase(event.id);

    result.fold(
      (failure) => emit(InterestsError(failure.message)),
      (interest) => emit(InterestLoaded(interest)),
    );
  }
}
