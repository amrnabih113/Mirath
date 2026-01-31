import 'package:dio/dio.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/my_constants.dart';
import '../../../../core/utils/my_logger.dart';
import '../../domain/entities/profile_setup_data.dart';
import '../models/follow_response_model.dart';
import '../models/get_user_response_model.dart';
import '../models/profile_header_response_model.dart';
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
        // Only include university if it has valid content (2+ characters)
        if (profileSetupData.university != null &&
            profileSetupData.university!.length >= 2)
          'university': profileSetupData.university,
      });

      // Add interests as individual fields (proper multipart/form-data array)
      for (var interest in profileSetupData.interests) {
        formData.fields.add(MapEntry('interests', interest));
      }

      MyLogger.debug(
        '[UsersRemoteDataSource] Form fields: ${formData.fields.map((e) => '${e.key}=${e.value}').join(', ')}',
      );

      // Add profile photo if available
      if (profileSetupData.profilePhoto != null) {
        final file = profileSetupData.profilePhoto!;
        formData.files.add(
          MapEntry(
            'profilePhoto',
            await MultipartFile.fromFile(file.path, filename: file.name),
          ),
        );
        MyLogger.info(
          '[UsersRemoteDataSource] Profile photo added: ${file.name}',
        );
      }

      final response = await dioClient.post(
        MyConstants.setupProfile,
        data: formData,
      );

      MyLogger.info('[UsersRemoteDataSource] Profile setup successful');
      return ProfileSetupResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      MyLogger.error('[UsersRemoteDataSource] Profile setup failed: $e');
      if (e.response != null) {
        MyLogger.error(
          '[UsersRemoteDataSource] Response data: ${e.response?.data}',
        );
        MyLogger.error(
          '[UsersRemoteDataSource] Status code: ${e.response?.statusCode}',
        );
      }
      rethrow;
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
  Future<ProfileHeaderResponseModel> getUserProfileHeader(String userId) async {
    try {
      MyLogger.info(
        '[UsersRemoteDataSource] Getting user profile header: $userId',
      );

      final endpoint = MyConstants.getUserProfileHeader.replaceAll(
        '{id}',
        userId,
      );
      final response = await dioClient.get(endpoint);

      MyLogger.info(
        '[UsersRemoteDataSource] Get user profile header successful',
      );
      return ProfileHeaderResponseModel.fromJson(response.data);
    } catch (e) {
      MyLogger.error(
        '[UsersRemoteDataSource] Get user profile header failed: $e',
      );
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
