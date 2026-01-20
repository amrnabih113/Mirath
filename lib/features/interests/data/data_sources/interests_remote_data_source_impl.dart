import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/my_constants.dart';
import '../models/interest_model.dart';
import 'interests_remote_data_source.dart';

class InterestsRemoteDataSourceImpl implements InterestsRemoteDataSource {
  final DioClient _dioClient;

  InterestsRemoteDataSourceImpl({required DioClient dioClient})
    : _dioClient = dioClient;

  @override
  Future<List<InterestModel>> getAllInterests() async {
    try {
      final response = await _dioClient.get(MyConstants.getAllInterests);

      final data = response.data;
      if (data != null && data['data'] != null) {
        final interestsList = data['data'] as List;
        return interestsList
            .map((interest) => InterestModel.fromJson(interest))
            .toList();
      }

      throw ServerException('Invalid response format');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<InterestModel> getInterestById(String id) async {
    try {
      final endpoint = MyConstants.getInterestById.replaceAll('{id}', id);
      final response = await _dioClient.get(endpoint);

      final data = response.data;
      if (data != null && data['data'] != null) {
        return InterestModel.fromJson(data['data']);
      }

      throw ServerException('Invalid response format');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
