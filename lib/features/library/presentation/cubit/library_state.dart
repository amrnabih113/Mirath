part of 'library_cubit.dart';

abstract class LibraryState {}

class LibraryInitial extends LibraryState {}

//1- Library Data States
class LibraryDataLoading extends LibraryState {}

class LibraryDataSuccess extends LibraryState {
  final LibraryData libraryData;

  LibraryDataSuccess({required this.libraryData});
}

class LibraryDataFailure extends LibraryState {
  final String errorMessage;

  LibraryDataFailure({required this.errorMessage});
}

// 2- Get Reading History States
class GetReadingHistoryLoading extends LibraryState {}

class GetReadingHistorySuccess extends LibraryState {
  final ReadingHistory readingHistory;

  GetReadingHistorySuccess({required this.readingHistory});
}

class GetReadingHistoryFailure extends LibraryState {
  final String errorMessage;

  GetReadingHistoryFailure({required this.errorMessage});
}

// 3- Update Reading History States
class UpdateReadingHistoryLoading extends LibraryState {}

class UpdateReadingHistorySuccess extends LibraryState {}

class UpdateReadingHistoryFailure extends LibraryState {
  final String errorMessage;

  UpdateReadingHistoryFailure({required this.errorMessage});
}

// 4- Clear All Reading History States
class ClearAllReadingHistoryLoading extends LibraryState {}

class ClearAllReadingHistorySuccess extends LibraryState {}

class ClearAllReadingHistoryFailure extends LibraryState {
  final String errorMessage;

  ClearAllReadingHistoryFailure({required this.errorMessage});
}

// 5- Get All Saved Papers States
class GetAllSavedPapersLoading extends LibraryState {}

class GetAllSavedPapersSuccess extends LibraryState {
  final List<SavedPapers> savedPapers;

  GetAllSavedPapersSuccess({required this.savedPapers});
}

class GetAllSavedPapersFailure extends LibraryState {
  final String errorMessage;

  GetAllSavedPapersFailure({required this.errorMessage});
}

// 6- Remove Paper From Reading History States
class RemovePaperFromReadingHistoryLoading extends LibraryState {}

class RemovePaperFromReadingHistorySuccess extends LibraryState {}

class RemovePaperFromReadingHistoryFailure extends LibraryState {
  final String errorMessage;

  RemovePaperFromReadingHistoryFailure({required this.errorMessage});
}
