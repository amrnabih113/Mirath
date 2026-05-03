import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/add_paper_to_list_params.dart';
import '../../domain/entities/create_reading_list_params.dart';
import '../../domain/entities/reading_list_query_params.dart';
import '../../domain/usecases/add_paper_to_list_usecase.dart';
import '../../domain/usecases/create_reading_list_usecase.dart';
import '../../domain/usecases/save_reading_list_usecase.dart';
import '../../domain/usecases/get_reading_list_by_id_usecase.dart';
import '../../domain/usecases/get_reading_lists_usecase.dart';
import '../../domain/usecases/remove_paper_from_list_usecase.dart';
import '../../domain/usecases/unsave_reading_list_usecase.dart';
import 'reading_list_state.dart';

class ReadingListCubit extends Cubit<ReadingListState> {
  final GetReadingListsUseCase getReadingListsUseCase;
  final CreateReadingListUseCase createReadingListUseCase;
  final GetReadingListByIdUseCase getReadingListByIdUseCase;
  final AddPaperToListUseCase addPaperToListUseCase;
  final RemovePaperFromListUseCase removePaperFromListUseCase;
  final SaveReadingListUseCase saveReadingListUseCase;
  final UnsaveReadingListUseCase unsaveReadingListUseCase;

  ReadingListQueryParams _currentQuery = const ReadingListQueryParams();

  ReadingListCubit({
    required this.getReadingListsUseCase,
    required this.createReadingListUseCase,
    required this.getReadingListByIdUseCase,
    required this.addPaperToListUseCase,
    required this.removePaperFromListUseCase,
    required this.saveReadingListUseCase,
    required this.unsaveReadingListUseCase,
  }) : super(const ReadingListInitial());

  Future<void> getReadingLists({ReadingListQueryParams? params}) async {
    _currentQuery = params ?? const ReadingListQueryParams();
    emit(const ReadingListLoading());

    final result = await getReadingListsUseCase(_currentQuery);

    result.fold(
      (failure) {
        emit(const ReadingListError(message: 'Failed to fetch reading lists'));
      },
      (readingLists) {
        emit(ReadingListsLoaded(readingLists  : readingLists));
      },
    );
  }

  Future<void> getUserReadingLists() async {
    await getReadingLists();
  }

  Future<void> getSavedReadingLists() async {
    await getReadingLists(params: const ReadingListQueryParams(saved: true));
  }

  Future<void> getAllReadingLists() async {
    await getReadingLists(params: const ReadingListQueryParams(all: true));
  }

  Future<void> getOwnerReadingLists(String ownerId) async {
    await getReadingLists(params: ReadingListQueryParams(ownerId: ownerId));
  }

  Future<void> createReadingList(CreateReadingListParams params) async {
    final result = await createReadingListUseCase(params);

    result.fold(
      (failure) {
        emit(const ReadingListError(message: 'Failed to create reading list'));
      },
      (readingList) {
        // Reload the lists after creation
        getReadingLists(params: _currentQuery);
      },
    );
  }

  Future<void> getReadingListById(String id) async {
    emit(const ReadingListLoading());

    final result = await getReadingListByIdUseCase(id);

    result.fold(
      (failure) {
        emit(const ReadingListError(message: 'Failed to fetch reading list'));
      },
      (readingList) {
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
        emit(
          const ReadingListOperationSuccess(
            message: 'Paper added successfully',
          ),
        );
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
        emit(
          const ReadingListOperationSuccess(
            message: 'Paper removed successfully',
          ),
        );
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
