import 'package:dio/dio.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/my_constants.dart';
import '../../../../core/utils/my_logger.dart';
import '../../domain/entities/profile_setup_data.dart';
import '../models/follow_response_model.dart';
import '../models/get_user_response_model.dart';
import '../models/profile_setup_response_model.dart';
import 'users_remote_data_source.dart';

class UsersRemoteDataSourceImpl implements UsersRemoteDataSource {
  final DioClient dioClient;

  const UsersRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<ProfileSetupResponseModel> setupProfile(
    ProfileSetupData profileSetupData,
  ) async {
    try {
      MyLogger.info('[UsersRemoteDataSource] Setting up profile...');

      final formData = FormData.fromMap({
        'name': profileSetupData.name,
        'levelOfEducation': profileSetupData.levelOfEducation,
        'interests': profileSetupData.interests.join(', '),
        // Only include university if it has valid content (2+ characters)
        if (profileSetupData.university != null &&
            profileSetupData.university!.length >= 2)
          'university': profileSetupData.university,
      });

      final response = await dioClient.post(
        MyConstants.setupProfile,
        data: formData,
      );

      MyLogger.info('[UsersRemoteDataSource] Profile setup successful');
      return ProfileSetupResponseModel.fromJson(response.data);
    } catch (e) {
      MyLogger.error('[UsersRemoteDataSource] Profile setup failed: $e');
      rethrow;
    }
  }

  @override
  Future<GetUserResponseModel> getCurrentUser() async {
    try {
      MyLogger.info('[UsersRemoteDataSource] Getting current user...');

      final response = await dioClient.get(MyConstants.getMe);

      MyLogger.info('[UsersRemoteDataSource] Get current user successful');
      return GetUserResponseModel.fromJson(response.data);
    } catch (e) {
      MyLogger.error('[UsersRemoteDataSource] Get current user failed: $e');
      rethrow;
    }
  }

  @override
  Future<FollowResponseModel> followUser(String userId) async {
    try {
      MyLogger.info('[UsersRemoteDataSource] Following user: $userId');

      final endpoint = MyConstants.followUser.replaceAll('{id}', userId);
      final response = await dioClient.post(endpoint);

      MyLogger.info('[UsersRemoteDataSource] Follow user successful');
      return FollowResponseModel.fromJson(response.data);
    } catch (e) {
      MyLogger.error('[UsersRemoteDataSource] Follow user failed: $e');
      rethrow;
    }
  }

  @override
  Future<FollowResponseModel> unfollowUser(String userId) async {
    try {
      MyLogger.info('[UsersRemoteDataSource] Unfollowing user: $userId');

      final endpoint = MyConstants.unfollowUser.replaceAll('{id}', userId);
      final response = await dioClient.delete(endpoint);

      MyLogger.info('[UsersRemoteDataSource] Unfollow user successful');
      return FollowResponseModel.fromJson(response.data);
    } catch (e) {
      MyLogger.error('[UsersRemoteDataSource] Unfollow user failed: $e');
      rethrow;
    }
  }
}
