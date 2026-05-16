import 'package:bloc/bloc.dart';

import '../../../../core/cache/cache_keys.dart';
import '../../../../core/cache/cache_notifier.dart';
import '../../../../core/cache/hive_cache_service.dart';
import '../../data/models/library_data_model.dart';
import '../../domain/entities/library_data.dart';
import '../../domain/entities/reading_history.dart';
import '../../domain/entities/saved_papers.dart';
import '../../domain/usecases/clear_all_reading_history.dart';
import '../../domain/usecases/get_all_saved_papers.dart';
import '../../domain/usecases/get_library_data.dart';
import '../../domain/usecases/get_reading_history.dart';
import '../../domain/usecases/remove_paper_from_reading_history.dart';
import '../../domain/usecases/update_reading_history.dart';

part 'library_state.dart';

class LibraryCubit extends Cubit<LibraryState> {
  LibraryCubit({
    required this.getLibraryDataUseCase,
    required this.getReadingHistoryUseCase,
    required this.updateReadingHistoryUseCase,
    required this.clearAllReadingHistoryUseCase,
    required this.getAllSavedPapersUseCase,
    required this.removePaperFromReadingHistoryUseCase,
    required this.cacheService,
  }) : super(LibraryInitial()) {
    CacheNotifier.instance.stream.listen((key) {
      if (key == CacheKeys.libraryStats()) {
        _onLibraryStatsUpdated();
      }
    });
  }
  final GetLibraryData getLibraryDataUseCase;
  final GetReadingHistory getReadingHistoryUseCase;
  final UpdateReadingHistory updateReadingHistoryUseCase;
  final ClearAllReadingHistory clearAllReadingHistoryUseCase;
  final GetAllSavedPapers getAllSavedPapersUseCase;
  final RemovePaperFromReadingHistory removePaperFromReadingHistoryUseCase;
  final HiveCacheService cacheService;
  //1- Library Data Function
  Future<void> getLibraryData() async {
    emit(LibraryDataLoading());
    var result = await getLibraryDataUseCase.call();
    result.fold(
      (failure) {
        // Try to read stale cached data if available
        try {
          cacheService
              .getJson(CacheKeys.libraryStats())
              .then((cached) {
                if (cached != null) {
                  final cachedModel = LibraryDataModel.fromJson(cached);
                  emit(
                    LibraryDataSuccess(
                      libraryData: cachedModel,
                      fromCache: true,
                    ),
                  );
                  return;
                }
                emit(LibraryDataFailure(errorMessage: failure.message));
              })
              .catchError((_) {
                emit(LibraryDataFailure(errorMessage: failure.message));
              });
        } catch (e) {
          emit(LibraryDataFailure(errorMessage: failure.message));
        }
      },
      (libData) {
        emit(LibraryDataSuccess(libraryData: libData, fromCache: false));
      },
    );
  }

  Future<void> _onLibraryStatsUpdated() async {
    final cached = await cacheService.getJson(
      CacheKeys.libraryStats(),
      allowStale: true,
    );
    if (cached != null) {
      final model = LibraryDataModel.fromJson(cached);
      emit(LibraryDataSuccess(libraryData: model, fromCache: false));
    }
  }

  // 2- Get Reading History Function
  Future<void> getReadingHistory({
    int page = 1,
    int limit = 20,
    bool loadMore = false,
  }) async {
    final currentState = state;

    if (loadMore && currentState is GetReadingHistorySuccess) {
      if (!currentState.hasMore || currentState.isLoadingMore) {
        return;
      }
      emit(
        GetReadingHistorySuccess(
          readingHistory: currentState.readingHistory,
          currentPage: currentState.currentPage,
          hasMore: currentState.hasMore,
          isLoadingMore: true,
        ),
      );
    } else {
      emit(GetReadingHistoryLoading());
    }

    var result = await getReadingHistoryUseCase.call(page: page, limit: limit);
    result.fold(
      (failure) {
        if (loadMore && currentState is GetReadingHistorySuccess) {
          emit(
            GetReadingHistorySuccess(
              readingHistory: currentState.readingHistory,
              currentPage: currentState.currentPage,
              hasMore: currentState.hasMore,
              isLoadingMore: false,
            ),
          );
          return;
        }
        emit(GetReadingHistoryFailure(errorMessage: failure.message));
      },
      (readHis) {
        final mergedList = loadMore && currentState is GetReadingHistorySuccess
            ? [...currentState.readingHistory, ...readHis]
            : readHis;

        emit(
          GetReadingHistorySuccess(
            readingHistory: mergedList,
            currentPage: page,
            hasMore: readHis.length == limit,
            isLoadingMore: false,
          ),
        );
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
