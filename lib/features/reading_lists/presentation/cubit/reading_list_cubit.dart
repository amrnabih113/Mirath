import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirath/core/network/network_manager.dart';
import '../../domain/entities/add_paper_to_list_params.dart';
import '../../domain/entities/create_reading_list_params.dart';
import '../../domain/entities/reading_list_query_params.dart';
import '../../domain/usecases/add_paper_to_list_usecase.dart';
import '../../domain/usecases/create_reading_list_usecase.dart';
import '../../domain/usecases/reading_list_cache_usecases.dart';
import '../../domain/usecases/save_reading_list_usecase.dart';
import '../../domain/usecases/get_reading_list_by_id_usecase.dart';
import '../../domain/usecases/get_reading_lists_usecase.dart';
import '../../domain/usecases/remove_paper_from_list_usecase.dart';
import '../../domain/usecases/unsave_reading_list_usecase.dart';
import 'reading_list_state.dart';

class ReadingListCubit extends Cubit<ReadingListState> {
  final ReadingListCacheUseCases readingListCacheUseCases;
  final GetReadingListsUseCase getReadingListsUseCase;
  final CreateReadingListUseCase createReadingListUseCase;
  final GetReadingListByIdUseCase getReadingListByIdUseCase;
  final AddPaperToListUseCase addPaperToListUseCase;
  final RemovePaperFromListUseCase removePaperFromListUseCase;
  final SaveReadingListUseCase saveReadingListUseCase;
  final UnsaveReadingListUseCase unsaveReadingListUseCase;

  ReadingListQueryParams _currentQuery = const ReadingListQueryParams();

  ReadingListCubit({
    required this.readingListCacheUseCases,
    required this.getReadingListsUseCase,
    required this.createReadingListUseCase,
    required this.getReadingListByIdUseCase,
    required this.addPaperToListUseCase,
    required this.removePaperFromListUseCase,
    required this.saveReadingListUseCase,
    required this.unsaveReadingListUseCase,
  }) : super(const ReadingListInitial());

  Future<void> getReadingLists({
    ReadingListQueryParams? params,
    bool forceRefresh = false,
  }) async {
    if (forceRefresh && !await NetworkManager.instance.isConnected) {
      return;
    }

    _currentQuery = params ?? const ReadingListQueryParams();

    final cachedReadingLists = await readingListCacheUseCases
        .getCachedReadingLists(_currentQuery);

    if (cachedReadingLists.isNotEmpty) {
      emit(ReadingListsLoaded(readingLists: cachedReadingLists));
    } else {
      emit(const ReadingListLoading());
    }

    if (cachedReadingLists.isNotEmpty && !forceRefresh) {
      return;
    }

    final result = await getReadingListsUseCase(_currentQuery);

    result.fold(
      (failure) {
        if (cachedReadingLists.isEmpty) {
          emit(
            const ReadingListError(message: 'Failed to fetch reading lists'),
          );
        }
      },
      (readingLists) {
        readingListCacheUseCases.cacheReadingLists(readingLists, _currentQuery);
        emit(ReadingListsLoaded(readingLists: readingLists));
      },
    );
  }

  Future<void> getUserReadingLists({bool forceRefresh = false}) async {
    await getReadingLists(forceRefresh: forceRefresh);
  }

  Future<void> getSavedReadingLists({bool forceRefresh = false}) async {
    await getReadingLists(
      params: const ReadingListQueryParams(saved: true),
      forceRefresh: forceRefresh,
    );
  }

  Future<void> getAllReadingLists({bool forceRefresh = false}) async {
    await getReadingLists(
      params: const ReadingListQueryParams(all: true),
      forceRefresh: forceRefresh,
    );
  }

  Future<void> getOwnerReadingLists(
    String ownerId, {
    bool forceRefresh = false,
  }) async {
    await getReadingLists(
      params: ReadingListQueryParams(ownerId: ownerId),
      forceRefresh: forceRefresh,
    );
  }

  Future<void> createReadingList(CreateReadingListParams params) async {
    final result = await createReadingListUseCase(params);

    result.fold(
      (failure) {
        emit(const ReadingListError(message: 'Failed to create reading list'));
      },
      (readingList) {
        final currentState = state;
        if (currentState is ReadingListsLoaded) {
          final updatedLists = [readingList, ...currentState.readingLists];
          readingListCacheUseCases.cacheReadingLists(
            updatedLists,
            _currentQuery,
          );
          emit(currentState.copyWith(readingLists: updatedLists));
        } else {
          readingListCacheUseCases.upsertCachedReadingList(readingList);
          getReadingLists(params: _currentQuery);
        }
      },
    );
  }

  Future<void> getReadingListById(
    String id, {
    bool forceRefresh = false,
  }) async {
    if (forceRefresh && !await NetworkManager.instance.isConnected) {
      return;
    }

    final cachedReadingList = await readingListCacheUseCases
        .getCachedReadingListById(id);

    if (cachedReadingList != null) {
      emit(ReadingListDetailsLoaded(readingList: cachedReadingList));
    } else {
      emit(const ReadingListLoading());
    }

    final result = await getReadingListByIdUseCase(id);

    result.fold(
      (failure) {
        if (cachedReadingList == null) {
          emit(const ReadingListError(message: 'Failed to fetch reading list'));
        }
      },
      (readingList) {
        readingListCacheUseCases.updateReadingListDetailsCache(readingList);
        emit(ReadingListDetailsLoaded(readingList: readingList));
      },
    );
  }

  Future<void> addPaperToList({
    required String readingListId,
    required String paperId,
  }) async {
    final params = AddPaperToListParams(
      readingListId: readingListId,
      paperId: paperId,
    );

    final result = await addPaperToListUseCase(params);

    result.fold(
      (failure) {
        emit(const ReadingListError(message: 'Failed to add paper to list'));
      },
      (_) {
        final currentState = state;
        if (currentState is ReadingListDetailsLoaded) {
          emit(
            ReadingListDetailsLoaded(
              readingList: currentState.readingList.copyWith(
                paperCount: currentState.readingList.paperCount + 1,
              ),
            ),
          );
        } else {
          emit(
            const ReadingListOperationSuccess(
              message: 'Paper added successfully',
            ),
          );
        }
      },
    );
  }

  Future<void> removePaperFromList({
    required String readingListId,
    required String paperId,
  }) async {
    final params = RemovePaperParams(
      readingListId: readingListId,
      paperId: paperId,
    );

    final result = await removePaperFromListUseCase(params);

    result.fold(
      (failure) {
        emit(
          const ReadingListError(message: 'Failed to remove paper from list'),
        );
      },
      (_) {
        final currentState = state;
        if (currentState is ReadingListDetailsLoaded) {
          emit(
            ReadingListDetailsLoaded(
              readingList: currentState.readingList.copyWith(
                paperCount: currentState.readingList.paperCount > 0
                    ? currentState.readingList.paperCount - 1
                    : 0,
              ),
            ),
          );
        } else {
          emit(
            const ReadingListOperationSuccess(
              message: 'Paper removed successfully',
            ),
          );
        }
      },
    );
  }

  Future<void> saveReadingList(String id) async {
    final result = await saveReadingListUseCase(id);

    result.fold(
      (failure) {
        emit(const ReadingListError(message: 'Failed to save reading list'));
      },
      (_) {
        final currentState = state;
        if (currentState is ReadingListDetailsLoaded) {
          readingListCacheUseCases.updateReadingListSavedState(
            readingListId: id,
            isSaved: true,
          );
          emit(
            ReadingListDetailsLoaded(
              readingList: currentState.readingList.copyWith(isSaved: true),
            ),
          );
        }
      },
    );
  }

  Future<void> unsaveReadingList(String id) async {
    final result = await unsaveReadingListUseCase(id);

    result.fold(
      (failure) {
        emit(const ReadingListError(message: 'Failed to unsave reading list'));
      },
      (_) {
        final currentState = state;
        if (currentState is ReadingListDetailsLoaded) {
          readingListCacheUseCases.updateReadingListSavedState(
            readingListId: id,
            isSaved: false,
          );
          emit(
            ReadingListDetailsLoaded(
              readingList: currentState.readingList.copyWith(isSaved: false),
            ),
          );
        }
      },
    );
  }
}
