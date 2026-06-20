import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/no_params.dart';
import '../../domain/usecases/get_sessions_usecase.dart';
import '../../domain/usecases/delete_session_usecase.dart';
import '../../domain/usecases/create_temporary_session_usecase.dart';
import '../../domain/usecases/delete_temporary_session_usecase.dart';
import '../../domain/usecases/get_session_by_id_usecase.dart';
import '../../domain/entities/session.dart';
import 'sessions_state.dart';

class SessionsCubit extends Cubit<SessionsState> {
  SessionsCubit({
    required this.getSessionsUseCase,
    required this.deleteSessionUseCase,
    required this.createTemporarySessionUseCase,
    required this.deleteTemporarySessionUseCase,
    required this.getSessionByIdUseCase,
  }) : super(const SessionsInitial());

  final GetSessionsUseCase getSessionsUseCase;
  final DeleteSessionUseCase deleteSessionUseCase;
  final CreateTemporarySessionUseCase createTemporarySessionUseCase;
  final DeleteTemporarySessionUseCase deleteTemporarySessionUseCase;
  final GetSessionByIdUseCase getSessionByIdUseCase;

  Future<void> loadSessions() async {
    emit(const SessionsLoading());
    final res = await getSessionsUseCase(const NoParams());
    res.fold(
      (failure) {
        emit(SessionsError(message: failure.toString()));
      },
      (sessions) {
        emit(SessionsLoaded(sessions: sessions));
      },
    );
  }

  Future<void> removeSession(String id) async {
    final res = await deleteSessionUseCase(id);
    res.fold((failure) {}, (r) async {
      await loadSessions();
    });
  }

  Future<void> createTemporary() async {
    final res = await createTemporarySessionUseCase(const NoParams());
    res.fold((failure) {}, (Session r) async {
      await loadSessions();
    });
  }

  Future<void> deleteTemporary(String id) async {
    final res = await deleteTemporarySessionUseCase(id);
    res.fold((failure) {}, (r) async {
      await loadSessions();
    });
  }

  Future<Session?> getById(String id) async {
    final res = await getSessionByIdUseCase(id);
    return res.fold((f) => null, (m) => m);
  }
}
