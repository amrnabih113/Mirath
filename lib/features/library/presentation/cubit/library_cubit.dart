import 'package:bloc/bloc.dart';
import 'package:mirath/features/library/domain/entities/library_data.dart';
import 'package:mirath/features/library/domain/entities/reading_history.dart';
import 'package:mirath/features/library/domain/entities/saved_papers.dart';
import 'package:mirath/features/library/domain/usecases/clear_all_reading_history.dart';
import 'package:mirath/features/library/domain/usecases/get_all_saved_papers.dart';
import 'package:mirath/features/library/domain/usecases/get_library_data.dart';
import 'package:mirath/features/library/domain/usecases/get_reading_history.dart';
import 'package:mirath/features/library/domain/usecases/remove_paper_from_reading_history.dart';
import 'package:mirath/features/library/domain/usecases/update_reading_history.dart';

part 'library_state.dart';

class LibraryCubit extends Cubit<LibraryState> {
  LibraryCubit({
    required this.getLibraryDataUseCase,
    required this.getReadingHistoryUseCase,
    required this.updateReadingHistoryUseCase,
    required this.clearAllReadingHistoryUseCase,
    required this.getAllSavedPapersUseCase,
    required this.removePaperFromReadingHistoryUseCase,
  }) : super(LibraryInitial());
  final GetLibraryData getLibraryDataUseCase;
  final GetReadingHistory getReadingHistoryUseCase;
  final UpdateReadingHistory updateReadingHistoryUseCase;
  final ClearAllReadingHistory clearAllReadingHistoryUseCase;
  final GetAllSavedPapers getAllSavedPapersUseCase;
  final RemovePaperFromReadingHistory removePaperFromReadingHistoryUseCase;
  //1- Library Data Function
  Future<void> getLibraryData() async {
    emit(LibraryDataLoading());
    var result = await getLibraryDataUseCase.call();
    result.fold(
      (failure) {
        emit(LibraryDataFailure(errorMessage: failure.message));
      },
      (libData) {
        emit(LibraryDataSuccess(libraryData: libData));
      },
    );
  }

  // 2- Get Reading History Function
  Future<void> getReadingHistory() async {
    emit(GetReadingHistoryLoading());
    var result = await getReadingHistoryUseCase.call();
    result.fold(
      (failure) {
        emit(GetReadingHistoryFailure(errorMessage: failure.message));
      },
      (readHis) {
        emit(GetReadingHistorySuccess(readingHistory: readHis));
      },
    );
  }

  // 3- Update Reading History Function
  Future<void> updataReadingHistory(String paperId) async {
    emit(UpdateReadingHistoryLoading());
    var result = await updateReadingHistoryUseCase.call(paperId);
    result.fold(
      (failure) {
        emit(UpdateReadingHistoryFailure(errorMessage: failure.message));
      },
      (_) {
        emit(UpdateReadingHistorySuccess());
      },
    );
  }

  // 4- Clear All Reading History Function
  Future<void> clearAllReadingHistory() async {
    emit(ClearAllReadingHistoryLoading());
    var result = await clearAllReadingHistoryUseCase.call();
    result.fold(
      (failure) {
        emit(ClearAllReadingHistoryFailure(errorMessage: failure.message));
      },
      (_) {
        emit(ClearAllReadingHistorySuccess());
      },
    );
  }

  // 5- Get All Saved Papers Function
  Future<void> getAllSavedPapers() async {
    emit(GetAllSavedPapersLoading());
    var result = await getAllSavedPapersUseCase.call();
    result.fold(
      (failure) {
        emit(GetAllSavedPapersFailure(errorMessage: failure.message));
      },
      (savedPapers) {
        emit(GetAllSavedPapersSuccess(savedPapers: savedPapers));
      },
    );
  }

  // 6- Remove Paper From Reading History Function
  Future<void> removePaperFromReadingHistory(String paperId) async {
    emit(RemovePaperFromReadingHistoryLoading());
    var result = await removePaperFromReadingHistoryUseCase.call(paperId);
    result.fold(
      (failure) {
        emit(
          RemovePaperFromReadingHistoryFailure(errorMessage: failure.message),
        );
      },
      (_) {
        emit(RemovePaperFromReadingHistorySuccess());
      },
    );
  }
}
