import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/add_paper_to_list_params.dart';
import '../../domain/entities/create_reading_list_params.dart';
import '../../domain/usecases/add_paper_to_list_usecase.dart';
import '../../domain/usecases/create_reading_list_usecase.dart';
import '../../domain/usecases/get_reading_list_by_id_usecase.dart';
import '../../domain/usecases/get_reading_lists_usecase.dart';
import '../../domain/usecases/remove_paper_from_list_usecase.dart';
import 'reading_list_state.dart';

class ReadingListCubit extends Cubit<ReadingListState> {
  final GetReadingListsUseCase getReadingListsUseCase;
  final CreateReadingListUseCase createReadingListUseCase;
  final GetReadingListByIdUseCase getReadingListByIdUseCase;
  final AddPaperToListUseCase addPaperToListUseCase;
  final RemovePaperFromListUseCase removePaperFromListUseCase;

  ReadingListCubit({
    required this.getReadingListsUseCase,
    required this.createReadingListUseCase,
    required this.getReadingListByIdUseCase,
    required this.addPaperToListUseCase,
    required this.removePaperFromListUseCase,
  }) : super(const ReadingListInitial());

  Future<void> getReadingLists({String? ownerId}) async {
    emit(const ReadingListLoading());

    final result = await getReadingListsUseCase(ownerId);

    result.fold(
      (failure) {
        emit(const ReadingListError(message: 'Failed to fetch reading lists'));
      },
      (readingLists) {
        emit(ReadingListsLoaded(readingLists: readingLists));
      },
    );
  }

  Future<void> createReadingList(CreateReadingListParams params) async {
    final result = await createReadingListUseCase(params);

    result.fold(
      (failure) {
        emit(const ReadingListError(message: 'Failed to create reading list'));
      },
      (readingList) {
        // Reload the lists after creation
        getReadingLists();
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
}
