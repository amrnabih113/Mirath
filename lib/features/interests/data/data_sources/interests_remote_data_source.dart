import '../models/interest_model.dart';

abstract class InterestsRemoteDataSource {
  /// Get all predefined interests from the server
  ///
  /// Throws [ServerException] for all error codes.
  Future<List<InterestModel>> getAllInterests();

  /// Get a specific interest by its ID
  ///
  /// Throws [ServerException] for all error codes.
  Future<InterestModel> getInterestById(String id);
}
