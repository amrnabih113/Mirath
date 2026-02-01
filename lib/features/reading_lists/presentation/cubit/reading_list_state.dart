import '../../domain/entities/reading_list.dart';

abstract class ReadingListState {
  const ReadingListState();
}

class ReadingListInitial extends ReadingListState {
  const ReadingListInitial();
}

class ReadingListLoading extends ReadingListState {
  const ReadingListLoading();
}

class ReadingListsLoaded extends ReadingListState {
  final List<ReadingList> readingLists;
  final bool isLoadingMore;

  const ReadingListsLoaded({
    required this.readingLists,
    this.isLoadingMore = false,
  });

  ReadingListsLoaded copyWith({
    List<ReadingList>? readingLists,
    bool? isLoadingMore,
  }) {
    return ReadingListsLoaded(
      readingLists: readingLists ?? this.readingLists,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class ReadingListDetailsLoaded extends ReadingListState {
  final ReadingList readingList;

  const ReadingListDetailsLoaded({required this.readingList});
}

class ReadingListError extends ReadingListState {
  final String message;

  const ReadingListError({required this.message});
}

class ReadingListOperationSuccess extends ReadingListState {
  final String message;

  const ReadingListOperationSuccess({required this.message});
}
