import 'package:dartz/dartz.dart';
import '../../../../core/error/failuors.dart';
import '../entities/add_paper_to_list_params.dart';
import '../entities/create_reading_list_params.dart';
import '../entities/reading_list.dart';

abstract class ReadingListRepository {
  Future<Either<Failure, List<ReadingList>>> getReadingLists({String? ownerId});

  Future<Either<Failure, ReadingList>> createReadingList(
    CreateReadingListParams params,
  );

  Future<Either<Failure, ReadingList>> getReadingListById(String id);

  Future<Either<Failure, void>> addPaperToList(AddPaperToListParams params);

  Future<Either<Failure, void>> removePaperFromList({
    required String readingListId,
    required String paperId,
  });
}
